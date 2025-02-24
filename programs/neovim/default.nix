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
      cmp-async-path
      cmp-buffer
      cmp-nvim-lsp
      fidget-nvim
      gitsigns-nvim
      lsp-format-nvim
      lualine-nvim
      neo-tree-nvim
      nvim-autopairs
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-web-devicons # for lualine
      vim-wakatime
    ];
  };
}
