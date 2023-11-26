{
  pkgs,
  lib,
  ...
}: {
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [nix-your-shell];

  hm.programs.fish = {
    enable = true;

    interactiveShellInit = with pkgs; ''
      ${lib.getExe starship} init fish | source
      ${lib.getExe nix-your-shell} fish | source
    '';

    functions = {
      fish_greeting = "";
      kssh = "${lib.getExe pkgs.kitty} +kitten ssh $argv";
    };
  };
}
