{ pkgs, camasca, ... }:
{
  imports = [
    camasca.nixosModules.asus-numpad
    ../../programs/niri
    ../../programs/games.nix
    ../../programs/dotnet.nix
  ];

  environment.systemPackages = [
    pkgs.jetbrains.datagrip
    pkgs.foliate
  ];

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
        local all leo peer
        local all all md5
      '';
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb_1011;
    };
  };
}
