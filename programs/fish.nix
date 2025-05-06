{ pkgs, ... }:
{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    fishPlugins.hydro
  ];

  hjem.users.leo.files.".config/fish/config.fish".text = ''
    function fish_greeting
    end

    if status is-interactive
      set --global hydro_symbol_git_dirty "*"
      set --global hydro_color_pwd blue
      set --global hydro_color_git magenta
      set --global hydro_color_prompt green
      set --global hydro_color_duration yellow
    end
  '';
}
