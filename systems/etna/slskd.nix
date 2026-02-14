{ config, _utils, ... }:
let
  envFile = _utils.setupSingleSecret config "slskdEnv" { };
in
{
  imports = [ envFile.generate ];

  services.slskd = {
    enable = true;
    domain = "slsk.uku.moe";
    environmentFile = envFile.path;
    openFirewall = true;

    settings = {
      instance_name = "etna";
      shares = {
        directories = [ "/data/music" ];
        filters = [
          "\.ini$"
          "\.fish$"
        ];
        cache = {
          storage_mode = "memory";
          retention = 10080; # 1 week
        };
      };

      global.upload = {
        slots = 20;
        speed_limit = 10240; # 10 MiB
      };
    };
  };
}
