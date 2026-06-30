{ pkgs, ... }:
{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    (fishPlugins.hydro.overrideAttrs {
      version = "0-unstable-2026-06-30";

      src = pkgs.fetchFromGitHub {
        owner = "uku3lig";
        repo = "hydro";
        rev = "294bbaf5394a7eddb874a05b28550da3a8963c0b";
        hash = "sha256-OVOhoqdacKTj0muUXvymkRBm8hbLx7ZG7ns4HkOcrx0=";
      };
    })
  ];

  hj.".config/fish/config.fish".text = ''
    function fish_greeting
    end

    if status is-interactive
      set --global hydro_symbol_git_dirty "*"
      set --global hydro_color_pwd blue
      set --global hydro_color_git magenta
      set --global hydro_color_prompt green
      set --global hydro_color_duration yellow
      set --global hydro_color_ssh c570fa
    end
  '';
}
