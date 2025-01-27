{
  pkgs,
  config,
  _utils,
  ...
}:
let
  dbPass = _utils.setupSingleSecret config "roundcubeDbPass" {
    owner = "nginx";
  };
in
{
  imports = [ dbPass.generate ];

  services = {
    roundcube = {
      enable = true;
      hostName = "mail.uku3lig.net";
      dicts = with pkgs.aspellDicts; [
        en
        fr
      ];

      # nginx is automatically configured, ssl and acme are enabled

      database = {
        host = "etna";
        dbname = "roundcube";
        username = "roundcube";
        passwordFile = dbPass.path;
      };

      extraConfig = ''
        $config['imap_host'] = 'ssl://mx1.uku3lig.net:993';
        $config['smtp_host'] = 'ssl://mx1.uku3lig.net:465';
      '';
    };
  };
}
