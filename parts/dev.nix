{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [just nil];
    };

    formatter = pkgs.alejandra;
  };
}
