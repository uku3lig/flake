{ config, _utils, ... }:
let
  hostname = "mx1.uku3lig.net";
  certLocation = config.security.acme.certs.${hostname}.directory;

  env = _utils.setupSingleSecret config "maddyEnv" { };
in
{
  imports = [ env.generate ];

  security.acme.certs.${hostname} = {
    group = config.services.maddy.group;
    extraLegoRenewFlags = [ "--reuse-key" ]; # soopyc said its more secure
  };

  services.maddy = {
    enable = true;
    inherit hostname;
    primaryDomain = "uku3lig.net";
    localDomains = [
      "$(primary_domain)"
      "uku.moe"
    ];

    tls = {
      loader = "file";
      certificates = [
        {
          certPath = "${certLocation}/fullchain.pem";
          keyPath = "${certLocation}/key.pem";
        }
      ];
    };

    config = ''
      ## common stuff

      auth.pass_table local_authdb {
        table sql_table {
          driver postgres
          dsn "host=etna password={env:POSTGRES_PASSWORD} dbname=maddy sslmode=disable"
          table_name passwords
        }
      }

      storage.imapsql local_mailboxes {
        driver postgres
        dsn "host=etna password={env:POSTGRES_PASSWORD} dbname=maddy sslmode=disable"
        # TODO: imap_filter https://maddy.email/reference/storage/imap-filters/
      }

      # chain of steps applied to recipients
      # each step is a lookup table
      table.chain local_rewrites {
        # this removes the +suffix part from the address
        optional_step regexp "(.+)\+(.+)@(.+)" "$1@$3"
        optional_step static {
          entry postmaster postmaster@$(primary_domain)
        }
      }

      ## message reception

      msgpipeline local_routing {
        check {
          rspamd
        }

        modify {
          replace_rcpt &local_rewrites
        }

        # catch-all setup inspired by https://github.com/foxcpp/maddy/issues/243#issuecomment-1406567636
        # if the email is one of the already existing imap mailboxes, redirect to that directly
        destination_in &local_mailboxes {
          deliver_to &local_mailboxes
        }

        destination $(local_domains) {
          modify {
            replace_rcpt regexp ".*" "hi@uku.moe"
          }

          deliver_to &local_mailboxes
        }

        default_destination {
          reject 550 5.1.1 "User doesn't exist"
        }
      }

      smtp tcp://0.0.0.0:25 {
        limits {
          # Up to 20 msgs/sec across max. 10 SMTP connections.
          all rate 20 1s
          all concurrency 10
        }

        dmarc yes
        check {
          require_mx_record
          dkim
          spf
        }

        source $(local_domains) {
          reject 501 5.1.8 "Use internal submission port for outgoing SMTP"
        }

        default_source {
          destination postmaster $(local_domains) {
            deliver_to &local_routing
          }
          default_destination {
            reject 550 5.1.1 "User doesn't exist"
          }
        }
      }

      ## message sending

      target.remote outbound_delivery {
        limits {
          # Up to 20 msgs/sec across max. 10 SMTP connections for each recipient domain.
          destination rate 20 1s
          destination concurrency 10
        }

        mx_auth {
          dane
          mtasts
          local_policy {
            min_tls_level encrypted
            min_mx_level none
          }
        }
      }

      target.queue remote_queue {
        target &outbound_delivery

        # sender domain for DSNs (delivery status notifications)
        autogenerated_msg_domain $(primary_domain)

        # pipeline to know where to send DSNs
        bounce {
          destination postmaster $(local_domains) {
            deliver_to &local_routing
          }
          default_destination {
            reject 550 5.0.0 "Refusing to send DSNs to non-local addresses"
          }
        }
      }

      submission tls://0.0.0.0:465 tcp://0.0.0.0:587 {
        limits {
          # Up to 50 msgs/sec across any amount of SMTP connections.
          all rate 50 1s
        }

        auth &local_authdb

        source $(local_domains) {
          # make sure the sender is allowed to send from this server
          # local_rewrites allows us to use aliases as sender
          check {
            authorize_sender {
              prepare_email &local_rewrites
              user_to_email identity
            }
          }

          # just loop back if we are sending an email to ourselves
          destination postmaster $(local_domains) {
            deliver_to &local_routing
          }

          default_destination {
            modify {
              dkim $(primary_domain) $(local_domains) default
            }

            deliver_to &remote_queue
          }
        }

        default_source {
          reject 501 5.1.8 "Non-local sender domain"
        }
      }

      ## IMAP
      imap tls://0.0.0.0:993 {
        auth &local_authdb
        storage &local_mailboxes
      }
    '';
  };

  systemd.services.maddy.serviceConfig.EnvironmentFile = env.path;

  networking.firewall.allowedTCPPorts = [
    25 # smtp
    465 # submissions
    587 # submission (starttls)
    993 # imaps
  ];
}
