{
  self,
  inputs,
  ...
}: {
  perSystem = {
    lib,
    pkgs,
    system,
    ...
  }: {
    packages = let
      overlay = lib.fix (final: (import ../exprs/overlay.nix final pkgs));

      # do not include a package if it's not available on the system or if it's broken
      isValid = _: v:
        lib.elem pkgs.system (v.meta.platforms or [pkgs.system]) && !(v.meta.broken or false);
    in
      lib.filterAttrs isValid overlay;
  };

  flake.ghaMatrix.include = let
    inherit (inputs.nixpkgs) lib;

    platforms = {
      "x86_64-linux" = {
        os = "ubuntu-latest";
      };
    };
  in
    lib.pipe platforms [
      builtins.attrNames # get systems
      (systems: lib.getAttrs systems self.packages) # get packages of each system
      (lib.mapAttrs (_: builtins.attrNames)) # keep only the name of each package

      # map each package in each system to an attrset
      (lib.mapAttrsToList (system:
        builtins.map (pkg: {
          inherit (platforms.${system}) os;
          pkg = "packages.${system}.${pkg}";
        })))

      lib.flatten
    ];
}
