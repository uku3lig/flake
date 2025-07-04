{
  services.nginx = {
    enable = true;
    virtualHosts = {
      # default server
      "vps.uku3lig.net" = {
        default = true;
        addSSL = true;
        enableACME = true;
        locations."/".return = "404";
      };

      # immich
      "im.uku.moe" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://etna:2283";
          proxyWebsockets = true;
        };

        extraConfig = ''
          client_max_body_size 5000M;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };

      # dendrite
      "m.uku.moe" = {
        forceSSL = true;
        enableACME = true;
        locations =
          let
            server = {
              "m.server" = "m.uku.moe:443";
            };
            client = {
              "m.homeserver"."base_url" = "https://m.uku.moe";
            };
          in
          {
            "=/.well-known/matrix/server" = {
              return = "200 '${builtins.toJSON server}'";
            };

            "=/.well-known/matrix/client" = {
              return = "200 '${builtins.toJSON client}'";
            };

            "/" = {
              proxyPass = "http://etna:8008";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host      $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_read_timeout         600;
                client_max_body_size       100M;
              '';
            };
          };
      };

      "zipline.uku3lig.net" = {
        serverAliases = [ "v.uku.moe" ];
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://etna:3001";
          recommendedProxySettings = true;
        };

        extraConfig = ''
          client_max_body_size 1000M;
        '';
      };

      "git.uku3lig.net" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://etna:3000";
          recommendedProxySettings = true;
        };
      };
    };
  };

  # we depend on etna, which makes nginx fail if it's started before tailscale
  systemd.services.nginx.after = [ "tailscaled.service" ];
}
