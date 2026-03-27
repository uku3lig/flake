{
  services.memos = {
    enable = true;

    settings = {
      MEMOS_ADDR = "0.0.0.0";
      MEMOS_PORT = "5230";
      MEMOS_INSTANCE_URL = "https://memos.uku3lig.net";
      MEMOS_DRIVER = "postgres";
      MEMOS_DSN = "postgres:///memos?host=/run/postgresql";
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
