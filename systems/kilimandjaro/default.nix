{ pkgs, camasca, ... }:
{
  imports = [
    camasca.nixosModules.asus-numpad
    ../../programs/games.nix
    ../../programs/dotnet.nix
  ];

  environment.systemPackages = [ pkgs.jetbrains.datagrip ];

  services = {
    asus-numpad = {
      enable = true;
      settings.layout = "M433IA";
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb_1011;
    };
  };
}
