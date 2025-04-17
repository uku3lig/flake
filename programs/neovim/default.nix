{
  pkgs,
  getchvim,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (getchvim.packages.${system}.getchvim) makeNeovimWrapper;
in
{
  environment = {
    variables.EDITOR = "nvim";
    systemPackages = [
      (makeNeovimWrapper {
        pname = "ukuvim";

        luaRc = ./init.lua;

        runtimePrograms = with pkgs; [
          nixfmt-rfc-style
        ];

        vimPluginPackages = with pkgs.vimPlugins; [
          barbar-nvim
          catppuccin-nvim
          cmp-async-path
          cmp-buffer
          cmp-nvim-lsp
          direnv-vim
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
      })
    ];
  };
}
