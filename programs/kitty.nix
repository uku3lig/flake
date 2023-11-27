{
  hm.programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 12;
    };
    shellIntegration.enableFishIntegration = true;
    theme = "Catppuccin-Macchiato";

    extraConfig = ''
      tab_bar_edge bottom
      tab_bar_style powerline
      tab_powerline_style slanted
      tab_title_template {title}{' :{}:'.format(num_windows) if num_windows > 1 else '\'
    '';
  };
}
