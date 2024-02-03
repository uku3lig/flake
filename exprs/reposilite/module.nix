self: {
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.reposilite;

  inherit (pkgs.stdenv.hostPlatform) system;

  inherit
    (lib)
    getExe
    literalExpression
    mdDoc
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in {
  options.services.reposilite = {
    enable = mkEnableOption "reposilite";
    package = mkPackageOption self.packages.${system} "reposilite" {};
    environmentFile = mkOption {
      description = mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)`
      '';
      type = types.nullOr types.path;
      default = null;
      example = literalExpression ''
        "/run/agenix.d/1/reposilite"
      '';
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.reposilite = {
        isSystemUser = true;
        group = "reposilite";
      };

      groups.reposilite = {};
    };

    systemd.services."reposilite" = {
      enable = true;
      wantedBy = mkDefault ["multi-user.target"];
      after = mkDefault ["network.target"];
      script = ''
        ${getExe cfg.package}
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;

        StateDirectory = "reposilite";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/reposilite";

        User = "reposilite";
        Group = "reposilite";

        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };
  };
}
