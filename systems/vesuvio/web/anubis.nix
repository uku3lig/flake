{ config, ... }:
{
  # required due to unix socket permissions
  users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];

  services.anubis = {
    defaultOptions.policy.settings = {
      openGraph = {
        enabled = true;
        considerHost = false;
        ttl = "4h";
      };
    };

    # git.uku3lig.net
    instances."forgejo" = {
      settings = {
        TARGET = "http://etna:3000";
        BIND = "/run/anubis/anubis-forgejo/anubis.sock";
        METRICS_BIND = "/run/anubis/anubis-forgejo/anubis-metrics.sock";
      };

      policy.extraBots = [
        {
          name = "allow-git-nex";
          action = "ALLOW";
          expression = "userAgent.contains(\"GitNex\")";
        }
      ];
    };
  };
}
