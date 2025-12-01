{
  pkgs,
  getchvim,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (getchvim.packages.${system}.getchvim) mkNeovimWrapper;
in
{
  environment = {
    variables.EDITOR = "nvim";
    systemPackages = [
      (mkNeovimWrapper {
        pname = "ukuvim";

        luaRc = ./init.lua;

        runtimePrograms = with pkgs; [
          nixfmt-rfc-style
          zls
        ];

        vimPluginPackages = with pkgs.vimPlugins; [
          actions-preview-nvim
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
          telescope-nvim
          vim-wakatime
        ];
      })
    ];
  };
}
