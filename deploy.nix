{
  lib,
  self,
  inputs,
  ...
}: let
  systems = ["etna"];

  getDeploy = pkgs:
    (pkgs.appendOverlays [
      inputs.deploy-rs.overlay
      (_: prev: {
        deploy-rs = {
          inherit (pkgs) deploy-rs;
          inherit (prev.deploy-rs) lib;
        };
      })
    ])
    .deploy-rs;

  toDeployNode = hostname: system: {
    inherit hostname;
    sshUser = "root";

    profiles.system.path = let deploy = getDeploy system.pkgs; in deploy.lib.activate.nixos system;
  };
in {
  flake = {
    deploy = {
      remoteBuild = true;
      fastConnection = false;
      nodes = lib.mapAttrs toDeployNode (lib.getAttrs systems self.nixosConfigurations);
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
