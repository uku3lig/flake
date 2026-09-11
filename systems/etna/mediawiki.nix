{
  lib,
  pkgs,
  config,
  _utils,
  ...
}:
let
  password = _utils.setupSingleSecret config "mediawikiAdminPass" { owner = "mediawiki"; };
in
{
  imports = [ password.generate ];

  services.mediawiki = {
    enable = true;

    name = "uku's wiki";
    url = "https://wiki.uku3lig.net";

    extensions = {
      Cite = null;
      Math = null;
      SyntaxHighlight_GeSHi = null;
      VisualEditor = null;
    };

    webserver = "nginx";
    nginx.hostName = "wiki.uku3lig.net";
    passwordFile = password.path;
    database = {
      type = "postgres";
      createLocally = true;
    };

    extraConfig = ''
      # Disable reading by anonymous users
      $wgGroupPermissions['*']['read'] = false;

      # Disable anonymous editing
      $wgGroupPermissions['*']['edit'] = false;

      # Prevent new user registrations except by sysops
      $wgGroupPermissions['*']['createaccount'] = false;

      # Bundled pygmentize is just a python script, but adding python to the path doesn't seem to be enough
      $wgPygmentizePath = "${lib.getExe pkgs.python3Packages.pygments}";
    '';
  };
}
