{
  config,
  _utils,
  ...
}: let
  turnstileSecret = _utils.setupSingleSecret config "turnstileSecret" {
    owner = "forgejo";
    group = "forgejo";
  };
in {
  imports = [turnstileSecret.generate];

  cfTunnels."git.uku3lig.net" = "http://localhost:3000";

  services = {
    forgejo = {
      enable = true;

      database = {
        type = "postgres";
        createDatabase = true;
      };

      secrets = {
        service.CF_TURNSTILE_SECRET = turnstileSecret.path;
      };

      settings = {
        DEFAULT.APP_NAME = "uku's forge";

        server = {
          ROOT_URL = "https://git.uku3lig.net";
          START_SSH_SERVER = true;
          BUILTIN_SSH_SERVER_USER = "git";
          SSH_DOMAIN = "ssh.uku.moe";
          SSH_LISTEN_PORT = 2222;
        };

        service = {
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          ENABLE_CAPTCHA = true;
          CAPTCHA_TYPE = "cfturnstile";
          CF_TURNSTILE_SITEKEY = "0x4AAAAAAAaemJiXmRluMxbQ";
        };

        oauth2 = {
          # providers are configured in the admin panel
          ENABLED = true;
        };

        actions.ENABLED = false;

        "ui.meta" = {
          AUTHOR = "uku's forge";
          DESCRIPTION = "the place where literally nothing gets done";
        };

        "repository.signing" = {
          DEFAULT_TRUST_MODEL = "committer";
        };
      };
    };

    frp.settings.proxies = [
      {
        name = "forgejo-ssh";
        type = "tcp";
        localIp = "127.0.0.1";
        localPort = 2222;
        remotePort = 22;
      }
    ];
  };
}
