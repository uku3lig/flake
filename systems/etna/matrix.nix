{pkgs, ...}: {
  cfTunnels."m.uku.moe" = "http://localhost:80";

  services = {
    matrix-conduit = {
      enable = true;
      settings.global = {
        server_name = "m.uku.moe";
        allow_registration = true;
        port = 6167;
      };
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;

      virtualHosts."m.uku.moe" = {
        locations."=/.well-known/matrix/server" = let
          filename = "server-well-known";
          content = builtins.toJSON {"m.server" = "m.uku.moe:443";};
        in {
          alias = builtins.toString (pkgs.writeTextDir filename content) + "/";
          tryFiles = "${filename} =200";
          extraConfig = ''
            default_type application/json;
          '';
        };

        locations."/" = {
          proxyPass = "http://localhost:6167/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_buffering off;
            client_max_body_size 100M;
          '';
        };
      };
    };
  };
}
