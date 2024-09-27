{
  pkgs,
  lib,
  ...
}: {
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [nix-your-shell];

  hm.programs.fish = {
    enable = true;

    interactiveShellInit = ''
      ${lib.getExe pkgs.starship} init fish | source
      ${lib.getExe pkgs.nix-your-shell} fish | source
    '';

    functions.fish_greeting = "";
  };
}
