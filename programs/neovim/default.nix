{ pkgs, ... }:
{
  hm.programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./init.lua;

    extraPackages = with pkgs; [
      lua5_1
      nixfmt-rfc-style
      tree-sitter
    ];

    plugins = with pkgs.vimPlugins; [
      barbar-nvim
      catppuccin-nvim
      cmp-nvim-lsp
      lsp-format-nvim
      lualine-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-web-devicons # for lualine
    ];
  };
}
