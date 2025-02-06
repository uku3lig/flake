{
  services.nginx.virtualHosts = {
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
        proxyPass = "http://localhost:2283";
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
      locations."/" = {
        proxyPass = "http://etna:80";
        recommendedProxySettings = true;
      };
    };
  };
}
