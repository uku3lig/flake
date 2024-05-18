_: {
  cfTunnels."bw.uku3lig.net" = "http://localhost:8222";

  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://bw.uku3lig.net";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 8222;
    };
  };
}
