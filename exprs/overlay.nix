inputs: final: prev: {
  idea-wrapped = prev.callPackage ./idea-wrapped.nix { };
  pycharm-wrapped = prev.callPackage ./pycharm-wrapped.nix { };

  urbackup-client = prev.urbackup-client.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ final.autoreconfHook ];

    patches = old.patches or [ ] ++ [ ./urbackup-client-install.patch ];

    configureFlags = old.configureFlags or [ ] ++ [
      "--localstatedir=/var/lib"
    ];
  });

  jay = prev.jay.overrideAttrs (p: {
    version = "${p.version}+git.${inputs.jay.shortRev}";
    src = inputs.jay;

    cargoDeps = final.rustPlatform.importCargoLock {
      lockFile = "${inputs.jay}/Cargo.lock";
    };
  });
}
