{
  pkgs,
  ghostty,
  ...
}: {
  hm.home = {
    packages = [ghostty.packages.${pkgs.system}.default];

    file.".config/ghostty/config".text = ''
      theme = rose-pine
      font-family = Iosevka Nerd Font
      font-size = 12

      selection-foreground = #908caa
      selection-background = #26233a
    '';
  };
}
