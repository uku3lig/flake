{ config, _utils, ... }:
let
  livekitKey = _utils.setupSingleSecret config "livekitKey" { };
in
{
  imports = [ livekitKey.generate ];

  services = {
    livekit = {
      enable = true;
      openFirewall = true;
      keyFile = livekitKey.path;

      settings = {
        room.auto_create = false;
        rtc.use_external_ip = true;
      };
    };

    lk-jwt-service = {
      enable = true;
      port = 7890;
      keyFile = livekitKey.path;
      livekitUrl = "wss://rei.uku.moe/livekit/sfu";
    };

    # caution: the trailing slashes are important :-)
    nginx.virtualHosts."rei.uku.moe".locations = {
      "^~ /livekit/sfu/" = {
        proxyPass = "http://localhost:${toString config.services.livekit.settings.port}/";
        proxyWebsockets = true;
      };

      "^~ /livekit/jwt/" = {
        proxyPass = "http://localhost:${toString config.services.lk-jwt-service.port}/";
      };
    };
  };
}
