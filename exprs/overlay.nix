inputs: final: prev: {
  idea-wrapped = prev.callPackage ./idea-wrapped.nix { };
  pycharm-wrapped = prev.callPackage ./pycharm-wrapped.nix { };

  urbackup-client = prev.urbackup-client.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ prev.autoreconfHook ];

    patches = old.patches or [ ] ++ [ ./urbackup-client-install.patch ];

    configureFlags = old.configureFlags or [ ] ++ [
      "--localstatedir=/var/lib"
    ];
  });

  waywall = prev.waywall.overrideAttrs (
    f: p: {
      version = "0.2026.01.11";

      src = prev.fetchFromGitHub {
        owner = "tesselslate";
        repo = "waywall";
        tag = f.version;
        hash = "sha256-VOtwVFMGgUvsGnD1CnflKtUy5tTKqK2C/qNsWwgbyEU=";
      };
    }
  );
}
