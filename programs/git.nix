{
  programs.git.enable = true;

  hm.programs = {
    git = {
      enable = true;
      userName = "uku";
      userEmail = "uku3lig@gmail.com";

      signing = {
        key = "0D2F5CFF394C558D4F1C58937D01D7B105E77166";
        signByDefault = true;
      };

      extraConfig = {
        core.autocrlf = "input";
        push.autoSetupRemote = true;
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
