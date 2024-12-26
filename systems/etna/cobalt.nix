{ config, _utils, ... }:
let
  tokens = _utils.setupSingleSecret config "cobaltTokens" { };
in
{
  imports = [ tokens.generate ];

  cfTunnels."cobalt.uku3lig.net" = "http://localhost:9000";

  virtualisation.oci-containers.containers.cobalt = {
    image = "ghcr.io/imputnet/cobalt:10";
    user = "root:root";
    ports = [ "9000:9000/tcp" ];
    volumes = [ "${tokens.path}:/keys.json:ro" ];
    environment = {
      API_URL = "https://cobalt.uku3lig.net";
      API_AUTH_REQUIRED = "1";
      API_KEY_URL = "file:///keys.json";
    };
  };
}
