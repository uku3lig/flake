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
      version = "0.2026.01.11-unstable-2026-01-19";

      src = prev.fetchFromGitHub {
        owner = "tesselslate";
        repo = "waywall";
        rev = "0ba74cbd693fd0487912e40a274579410e5cc7e8";
        hash = "sha256-26eax/Cg8cfIrJni9MEMwnjeSDjCy61g+Wk7sus/TXE=";
      };
    }
  );
}
