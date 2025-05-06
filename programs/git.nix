{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    gh
  ];

  hjem.users.leo.files = {
    ".gitconfig".text = lib.generators.toGitINI {
      user = {
        name = "uku";
        email = "hi@uku.moe";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8";
      };

      commit = {
        gpgSign = true;
        verbose = true;
      };

      gpg.format = "ssh";
      tag.gpgSign = true;
      core.autocrlf = "input";
      diff.submodule = "log";
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      status.submoduleSummary = true;
      submodule.recurse = true;
    };

    ".config/gh/config.yml".text = lib.generators.toYAML { } {
      settings.git_protocol = "ssh";
    };
  };
}
