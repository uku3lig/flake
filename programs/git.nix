{
  programs.git.enable = true;

  hm.programs = {
    git = {
      enable = true;
      userName = "uku";
      userEmail = "hi@uku.moe";

      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        core.autocrlf = "input";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
      };
    };

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
