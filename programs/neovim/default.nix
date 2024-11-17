{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (lua5_1.withPackages (ps: with ps; [luarocks]))
  ];

  hm.programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
