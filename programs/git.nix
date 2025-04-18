{ config, ... }:
{
  programs.git.enable = true;

  hm.programs = {
    git = {
      inherit (config.programs.git) enable package;
      userName = "uku";
      userEmail = "hi@uku.moe";

      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8";
        signByDefault = true;
      };

      # delta.enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        core.autocrlf = "input";
        push.autoSetupRemote = true;
        merge.conflictStyle = "zdiff3";
        rebase.autoStash = true;
        status.submoduleSummary = true;
        diff.submodule = "log";
        submodule.recurse = true;
        commit.verbose = true;
      };
    };

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
