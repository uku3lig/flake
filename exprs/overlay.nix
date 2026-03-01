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

  python3Packages = prev.python3Packages.overrideScope (
    f: p: {
      picosvg = p.picosvg.overrideAttrs {
        patches = [
          # Fix test failures with skia-pathops 0.9.x (m143)
          # https://github.com/googlefonts/picosvg/pull/331
          (final.fetchpatch {
            url = "https://github.com/googlefonts/picosvg/commit/885ee64b75f526e938eb76e09fab7d93e946a355.patch";
            hash = "sha256-fR3FfnEPHwSO1rMtmQEr1pyvByTx8T53FxSpuAKWIjw=";
          })
        ];
      };
    }
  );

  jay = prev.jay.overrideAttrs (p: {
    version = "${p.version}+git.${inputs.jay.shortRev}";
    src = inputs.jay;

    nativeBuildInputs = p.nativeBuildInputs ++ [
      final.installShellFiles
    ];

    env = p.env // {
      RUSTC_BOOTSTRAP = 1;
    };

    cargoDeps = final.rustPlatform.importCargoLock {
      lockFile = "${inputs.jay}/Cargo.lock";
    };

    postPatch = ''
      sed -i '1s/^/#![feature(debug_closure_helpers)]\n/' src/main.rs
    '';

    postInstall = p.postInstall + ''
      install -D etc/jay.desktop $out/share/wayland-sessions/jay.desktop

      installShellCompletion --cmd jay \
        --bash <("$out/bin/jay" generate-completion bash) \
        --zsh <("$out/bin/jay" generate-completion zsh) \
        --fish <("$out/bin/jay" generate-completion fish)
    '';

    passthru.providedSessions = [ "jay" ];
  });
}
