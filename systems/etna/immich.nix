{ config, _utils, ... }:
let
  frp = _utils.mkFrpPassthrough "immich" config.services.immich.port;
in
{
  imports = [ frp ];

  services.immich = {
    enable = true;

    settings = null;
    mediaLocation = "/data/immich";

    environment = {
      TZ = "Europe/Paris";
    };
  };
}
