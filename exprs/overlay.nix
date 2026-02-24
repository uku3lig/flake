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

  vencord = prev.vencord.overrideAttrs (old: {
    version = "${old.version}+git.${inputs.vencord.shortRev}";
    src = inputs.vencord;

    env = old.env // {
      VENCORD_REMOTE = "Vendicated/Vencord";
      VENCORD_HASH = inputs.vencord.shortRev;
    };
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
}
