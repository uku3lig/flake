inputs: final: prev: {
  idea-ultimate-fixed = prev.callPackage ./idea-fixed.nix { };

  urbackup-client = prev.urbackup-client.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ prev.autoreconfHook ];

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

      ESBUILD_BINARY_PATH = prev.lib.getExe (
        prev.esbuild.overrideAttrs (
          final: _: {
            version = "0.25.0";
            src = prev.fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${final.version}";
              hash = "sha256-L9jm94Epb22hYsU3hoq1lZXb5aFVD4FC4x2qNt0DljA=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        )
      );
    };

    pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
      outputHash = "sha256-0afgeJkK0OQWoqF0b8pHPMsiTKox84YmwBhtNWGyVAg=";
      outputHashAlgo = "sha256";
    });
  });
}
