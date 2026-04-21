{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.jetbrains.rider ];

  systemd.tmpfiles.rules = [
    "L+ /opt/dotnet/10 - - - - ${pkgs.dotnet-sdk_10}/share/dotnet"
    "L+ /opt/dotnet/mono - - - - ${pkgs.mono}"
  ];
}
