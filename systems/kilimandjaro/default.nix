{
  pkgs,
  username,
  camasca,
  ...
}:
{
  imports = [
    camasca.nixosModules.asus-numpad
    ../../programs/niri
    ../../programs/dotnet.nix
  ];

  environment.systemPackages = [
    pkgs.foliate
  ];

  system.julie.games = {
    enable = true;
    mcsr.enable = true;
  };

  services = {
    asus-numpad = {
      enable = true;
      settings.layout = "M433IA";
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
      authentication = ''
        local all postgres peer
        local all ${username} peer
        local all all md5
      '';
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb_1011;
    };
  };
}
