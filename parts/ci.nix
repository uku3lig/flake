{
  self,
  lib,
  ...
}: {
  flake.hydraJobs = let
    mapCfgsToDerivs = lib.mapAttrs (_: cfg: cfg.activationPackage or cfg.config.system.build.toplevel);
  in {
    nixosConfigurations = mapCfgsToDerivs self.nixosConfigurations;
  };
}
