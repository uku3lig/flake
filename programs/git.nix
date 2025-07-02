{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    gh
  ];

  hj = {
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

      core = {
        autocrlf = "input";
        pager = "less --mouse";
      };

      gpg.format = "ssh";
      tag.gpgSign = true;
      diff.submodule = "log";
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      status.submoduleSummary = true;
      submodule.recurse = true;
    };

    ".config/gh/config.yml".text = lib.generators.toYAML { } {
      version = "1";
      settings.git_protocol = "ssh";
    };
  };
}
