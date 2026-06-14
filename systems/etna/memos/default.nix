{
  lib,
  pkgs,
  config,
  ...
}:
let
  mortis = pkgs.callPackage ./mortis.nix { };
  # NixOS/nixpkgs#531428
  memos = pkgs.memos.overrideAttrs (f: {
    ldflags = [
      "-X github.com/usememos/memos/internal/version.Version=${f.version}"
    ];
  });
in
{
  services.memos = {
    enable = true;
    package = memos;

    settings = {
      MEMOS_ADDR = "0.0.0.0";
      MEMOS_PORT = "5230";
      MEMOS_INSTANCE_URL = "https://memos.uku3lig.net";
      MEMOS_DRIVER = "postgres";
      MEMOS_DSN = "postgres:///memos?host=/run/postgresql";
      MEMOS_DATA = "/var/lib/memos";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "memos" ];
    ensureUsers = [
      {
        name = "memos";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services = {
    memos.serviceConfig = {
      Restart = "always";
      RestartSec = lib.mkForce "5s";
    };

    mortis = {
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe mortis} -port 5231 -grpc-addr 127.0.0.1:${config.services.memos.settings.MEMOS_PORT}";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };
}
