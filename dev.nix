{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        fzf
        just
        nil
      ];
    };

    formatter = pkgs.alejandra;
  };
}
