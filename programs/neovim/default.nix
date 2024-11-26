{pkgs, ...}: {
  hm.programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./init.lua;

    extraPackages = with pkgs; [
      (lua5_1.withPackages (ps: with ps; [luarocks]))
      tree-sitter
    ];

    plugins = with pkgs.vimPlugins; [
      barbar-nvim
      catppuccin-nvim
      lualine-nvim
      nvim-treesitter.withAllGrammars
      nvim-web-devicons # for lualine
    ];
  };
}
