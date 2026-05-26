{ pkgs, ... }:
{
  services.memos = {
    enable = true;
    package = pkgs.callPackage ./package.nix { };

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
}
