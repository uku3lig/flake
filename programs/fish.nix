{ pkgs, ... }:
{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    fishPlugins.hydro
  ];

  hm.programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set --global hydro_symbol_git_dirty "*"
      set --global hydro_color_pwd blue
      set --global hydro_color_git magenta
      set --global hydro_color_prompt green
      set --global hydro_color_duration yellow
    '';

    functions.fish_greeting = "";
  };
}
