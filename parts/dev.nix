{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        just
        nil
        statix
        deploy-rs
      ];
    };

    formatter = pkgs.alejandra;
  };
}
