{lib, ...}: {
  imports = lib.pipe ./. [
    builtins.readDir
    (lib.filterAttrs (n: _: n != "default.nix"))
    (lib.mapAttrsToList (n: _: ./${n}))
  ];
}
