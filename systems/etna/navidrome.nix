{
  config,
  _utils,
  ...
}: let
  cfg = config.services.navidrome;

  env = _utils.setupSingleSecret config "navidromeEnv" {
    inherit (cfg) group;
    owner = cfg.user;
  };
in {
  imports = [env.generate];

  cfTunnels."navidrome.uku3lig.net" = "http://localhost:4533";

  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/data/subsonic/music";
      BaseUrl = "https://navidrome.uku3lig.net";
    };
  };

  systemd.services.navidrome.serviceConfig = {
    EnvironmentFile = env.path;
    # https://github.com/NixOS/nixpkgs/pull/290901
    BindReadOnlyPaths = [
      "/run/systemd/resolve/stub-resolv.conf"
      "/run/systemd/resolve/resolv.conf"
    ];
  };
}
