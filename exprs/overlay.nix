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

  jay = prev.jay.overrideAttrs (
    f: p: {
      version = "1.13.0";

      src = p.src.overrideAttrs {
        rev = "refs/tags/v${f.version}";
        hash = "sha256-tC2V1BgUGsUMpZsKXjFSS8Mp28LrNI/QNu761zpgAkc=";
      };

      cargoDeps = prev.rustPlatform.fetchCargoVendor {
        inherit (f) src;
        hash = "sha256-96vCkZR/8dgZH0hJPeKzP7jQZ41W7XTi9yMnxFaIhoY=";
      };

      env = p.env // {
        RUSTC_BOOTSTRAP = 1;
      };

      postPatch = ''
        sed -i '1s/^/#![feature(cfg_select)]\n/' src/main.rs
      '';
    }
  );
}
