{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.jetbrains.rider ];

  systemd.tmpfiles.rules = [
    "L /opt/dotnet/8 - - - - ${pkgs.dotnet-sdk_8}/share/dotnet"
    "L /opt/dotnet/mono - - - - ${pkgs.mono}"
  ];
}
