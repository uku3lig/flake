{
  config,
  _utils,
  ...
}: let
  envFile = _utils.setupSingleSecret config "vaultwardenEnv" {};
in {
  imports = [envFile.generate];

  cfTunnels."bw.uku3lig.net" = "http://localhost:8222";

  services.vaultwarden = {
    enable = true;
    environmentFile = envFile.path;
    config = {
      DOMAIN = "https://bw.uku3lig.net";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 8222;

      SMTP_HOST = "in-v3.mailjet.com";
      SMTP_FROM = "vaultwarden@uku3lig.net";
      SMTP_PORT = 587;
      SMTP_SECURITY = "starttls";
    };
  };
}
