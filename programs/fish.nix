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
      if test -f ~/.ssh/id_ed25519
        ssh-add -l | grep -q (ssh-keygen -lf ~/.ssh/id_ed25519) || ssh-add ~/.ssh/id_ed25519
      end

      ${lib.getExe starship} init fish | source
      ${lib.getExe nix-your-shell} fish | source
    '';

    functions.fish_greeting = "";
  };
}
