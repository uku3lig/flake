# home-manager module
{
  programs.neovide = {
    enable = true;
    settings = {
      fork = true;
      font = {
        normal = "Iosevka";
        size = 12;
      };
    };
  };
}
