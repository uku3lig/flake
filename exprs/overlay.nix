inputs: final: prev: {
  idea-wrapped = prev.callPackage ./idea-wrapped.nix { };
  pycharm-wrapped = prev.callPackage ./pycharm-wrapped.nix { };
  google-sans = prev.callPackage ./google-sans.nix { };

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
        prev.esbuild.overrideAttrs rec {
          version = "0.25.1";
          src = prev.fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-vrhtdrvrcC3dQoJM6hWq6wrGJLSiVww/CNPlL1N5kQ8=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
    };

    pnpmDeps = old.pnpmDeps.overrideAttrs {
      outputHash = "sha256-hO6QKRr4jTfesRDAEGcpFeJmGTGLGMw6EgIvD23DNzw=";
    };
  });
}
