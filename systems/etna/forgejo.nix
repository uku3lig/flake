{
  pkgs,
  config,
  _utils,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    secrets = [
      "turnstileSecret"
      "forgejoRunnerSecret"
      "forgejoMailerPasswd"
    ];
    extra = {
      owner = "forgejo";
      group = "forgejo";
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
        createDatabase = true;
      };

      lfs.enable = true;

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
          START_SSH_SERVER = true;
          BUILTIN_SSH_SERVER_USER = "git";
          SSH_DOMAIN = "git.uku3lig.net";
          SSH_LISTEN_PORT = 2222;
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
          DESCRIPTION = "the place where literally nothing gets done";
        };

        "repository.signing" = {
          DEFAULT_TRUST_MODEL = "committer";
        };
      };
    };

    gitea-actions-runner = {
      package = pkgs.forgejo-actions-runner;
      instances.etna = {
        enable = true;
        name = "etna";
        url = "https://git.uku3lig.net";
        tokenFile = secrets.get "forgejoRunnerSecret";
        labels = [
          "ubuntu-latest:docker://catthehacker/ubuntu:act-latest"
        ];

        settings = {
          log.level = "info";
          container.network = "host";
          runner = {
            capacity = 4;
            timeout = "2h";
            insecure = false;
          };
        };
      };
    };

    frp.settings.proxies = [
      {
        name = "forgejo-ssh";
        type = "tcp";
        localIp = "127.0.0.1";
        localPort = config.services.forgejo.settings.server.SSH_LISTEN_PORT;
        remotePort = 22;
      }
    ];
  };
}
