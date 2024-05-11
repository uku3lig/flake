{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [just nil deploy-rs];
    };

    formatter = pkgs.alejandra;
  };
}
