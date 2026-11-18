{
  pkgs,
  config,
  _utils,
  ...
}:
let
  cfg = config.services.forgejo;

  secrets = _utils.setupSecrets config {
    secrets = [
      "turnstileSecret"
      "forgejoRunnerSecret"
      "forgejoMailerPasswd"
    ];
    extra = {
      owner = "git";
      group = "git";
    };
  };
in
{
  imports = [ secrets.generate ];

  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo; # forgejo-lts by default

      database = {
        type = "postgres";
        user = "git";
        socket = "/run/postgresql";
        createDatabase = false;
      };

      lfs.enable = true;

      user = "git";
      group = "git";

      secrets = {
        service.CF_TURNSTILE_SECRET = secrets.get "turnstileSecret";
        mailer.PASSWD = secrets.get "forgejoMailerPasswd";
      };

      settings = {
        DEFAULT.APP_NAME = "uku's forge";

        server = {
          ROOT_URL = "https://git.uku3lig.net";
          HTTP_ADDR = "0.0.0.0";
          HTTP_PORT = 3000;
          SSH_DOMAIN = "git.uku3lig.net";
        };

        service = {
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          REGISTER_EMAIL_CONFIRM = true;
          ENABLE_NOTIFY_MAIL = true;
          EMAIL_DOMAIN_BLOCK_DISPOSABLE = true;
          ENABLE_CAPTCHA = true;
          CAPTCHA_TYPE = "cfturnstile";
          CF_TURNSTILE_SITEKEY = "0x4AAAAAAAaemJiXmRluMxbQ";
        };

        security = {
          REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.0/8,::1/128,100.0.0.0/8";
        };

        oauth2 = {
          # providers are configured in the admin panel
          ENABLED = true;
        };

        mailer = {
          ENABLED = true;
          FROM = "\"uku's forge\" <services@uku3lig.net>";
          PROTOCOL = "smtps";
          SMTP_ADDR = "mx1.uku3lig.net";
          SMTP_PORT = 465;
          USER = "services@uku3lig.net";
        };

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "https://github.com";
        };

        indexer = {
          REPO_INDEXER_ENABLED = true;
        };

        "ui.meta" = {
          AUTHOR = "uku's forge";
          DESCRIPTION = "git forge for most of my personal projects";
        };

        "repository.signing" = {
          DEFAULT_TRUST_MODEL = "committer";
        };
      };
    };

    postgresql = {
      ensureDatabases = [ "forgejo" ];
      ensureUsers = [ { name = "git"; } ];
    };

    openssh.extraConfig = ''
      Match User git
        AcceptEnv GIT_PROTOCOL
    '';

    forgejo-runner.instances.etna = {
      enable = true;

      # automatically loadcredential'ed and added to the settings
      secrets.server.connections.default.token_url = secrets.get "forgejoRunnerSecret";

      settings = {
        server.connections.default = {
          url = "http://localhost:${toString cfg.settings.server.HTTP_PORT}";
          uuid = "6ef17887-3a7a-4bb7-91d3-03bce385e742";
        };

        runner.labels = [
          "ubuntu-latest:docker://catthehacker/ubuntu:act-latest"
        ];

        log.level = "info";
        container.network = "host";
        runner = {
          capacity = 4;
          timeout = "2h";
          insecure = false;
        };
      };
    };

    frp.instances.default.settings.proxies = [
      {
        name = "forgejo-ssh";
        type = "tcp";
        localIp = "127.0.0.1";
        localPort = 22;
        remotePort = 22;
      }
    ];

    borgbackup.jobs.forgejo = config.passthru.makeBorg "forgejo" cfg.stateDir;
  };

  users = {
    groups.git = { };
    users.git = {
      isSystemUser = true;
      useDefaultShell = true;
      home = cfg.stateDir;
      group = "git";
    };
  };
}
