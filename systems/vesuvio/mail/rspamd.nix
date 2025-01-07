{ config, _utils, ... }:
let
  password = _utils.setupSingleSecret config "rspamdPassword" {
    owner = config.services.rspamd.user;
    inherit (config.services.rspamd) group;
  };
in
{
  imports = [ password.generate ];

  services = {
    redis.servers.rspamd = {
      enable = true;
      user = config.services.rspamd.user;
      port = 0; # disable tcp
    };

    rspamd = {
      enable = true;
      locals = {
        "redis.conf".text = ''
          servers = ${config.services.redis.servers.rspamd.unixSocket};
        '';
      };

      workers = {
        controller.includes = [ password.path ];
        normal.bindSockets = [ "127.0.0.1:11333" ]; # maddy queries port 11333
      };
    };
  };
}
