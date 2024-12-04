{
  pkgs,
  ghostty,
  ...
}: {
  hm.home = {
    packages = [ghostty.packages.${pkgs.system}.default];

    file.".config/ghostty/config".text = ''
      theme = light:catppuccin-latte,dark:rose-pine
      font-family = Iosevka Nerd Font
      font-size = 12
      font-feature = -calt
      font-feature = -dlig

      selection-foreground = #908caa
      selection-background = #26233a
    '';
  };
}
