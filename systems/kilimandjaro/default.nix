{ camasca, ... }:
{
  imports = [
    camasca.nixosModules.asus-numpad
    ../../programs/games.nix
    ../../programs/dotnet.nix
  ];

  services.asus-numpad = {
    enable = true;
    settings.layout = "M433IA";
  };
}
