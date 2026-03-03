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

  weston = prev.weston.overrideAttrs (p: {
    patches = [
      (final.fetchpatch {
        url = "https://gitlab.freedesktop.org/wayland/weston/-/merge_requests/1993.patch";
        hash = "sha256-705GIM7drTzv0N5Hk5dO18LWBnhhi1VoX8sfITHRYc4=";
      })
    ];
  });

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
