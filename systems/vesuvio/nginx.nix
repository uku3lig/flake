{ config, ... }:
let
  anubisBind = name: config.services.anubis.instances.${name}.settings.BIND;
in
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      # default server
      "vps.uku3lig.net" = {
        default = true;
        addSSL = true;
        enableACME = true;
        locations."/".return = "404";
      };

      # immich
      "im.uku.moe" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://etna:2283";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        extraConfig = ''
          client_max_body_size 5000M;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };

      # synapse
      "rei.uku.moe" = {
        forceSSL = true;
        enableACME = true;
        locations =
          let
            server = {
              "m.server" = "rei.uku.moe:443";
            };
            client = {
              "m.homeserver"."base_url" = "https://rei.uku.moe";
            };
          in
          {
            "=/.well-known/matrix/server" = {
              return = "200 '${builtins.toJSON server}'";
            };

            "=/.well-known/matrix/client" = {
              return = "200 '${builtins.toJSON client}'";
            };

            "/" = {
              proxyPass = "http://etna:8009";
              proxyWebsockets = true;
              recommendedProxySettings = true;
              extraConfig = ''
                proxy_read_timeout         600;
                client_max_body_size       1000M;
              '';
            };
          };
      };

      "zipline.uku3lig.net" = {
        serverAliases = [ "v.uku.moe" ];
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://etna:3001";
          recommendedProxySettings = true;
        };

        extraConfig = ''
          client_max_body_size 1000M;
        '';
      };

      "git.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://unix:${anubisBind "forgejo"}";
          recommendedProxySettings = true;
        };

        extraConfig = ''
          client_max_body_size 200M;
        '';
      };

      "paper.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://etna:28981";
          recommendedProxySettings = true;
        };

        extraConfig = ''
          client_max_body_size 100M;
        '';
      };
    };
  };

  # we depend on etna, which makes nginx fail if it's started before tailscale
  systemd.services.nginx.after = [ "tailscaled.service" ];

  # required due to unix socket permissions
  users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];

  # anubis
  services.anubis.instances = {
    "forgejo".settings = {
      TARGET = "http://etna:3000";
      # TODO: I think this is not needed if you have 2 anubis instances
      BIND = "/run/anubis/anubis-forgejo/anubis.sock";
      # on everyone's miguel im not using metrics but module is yelling at me
      METRICS_BIND = "/run/anubis/anubis-forgejo/anubis-metrics.sock";
    };
  };
}
