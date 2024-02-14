{
  hm.programs.starship = {
    enable = true;
    settings =
      {
        add_newline = false;

        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
        };
      }
      // builtins.fromTOML (builtins.readFile ./nerd-font.toml);
  };
}
