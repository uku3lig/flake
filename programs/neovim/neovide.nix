# home-manager module
{
  programs.neovide = {
    enable = true;
    settings = {
      fork = true;
      font = {
        normal = "IosevkaTerm Nerd Font";
        size = 12;
      };
    };
  };
}
