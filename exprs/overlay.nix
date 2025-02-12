inputs: final: prev: {
  idea-ultimate-fixed = prev.callPackage ./idea-fixed.nix { };

  urbackup-client = prev.urbackup-client.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ prev.autoreconfHook ];

    patches = old.patches or [ ] ++ [ ./urbackup-client-install.patch ];

    configureFlags = old.configureFlags or [ ] ++ [
      "--localstatedir=/var/lib"
    ];
  });

  vencord = prev.vencord.overrideAttrs (old: rec {
    version = "${old.version}+git.${inputs.vencord.shortRev}";
    src = inputs.vencord;

    env = old.env // {
      VENCORD_REMOTE = "Vendicated/Vencord";
      VENCORD_HASH = src.shortRev;
    };

    pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
      outputHash = "sha256-ZUwtNtOmxjhOBpYB7vuytunGBRSuVxdlQsceRmeyhhI=";
      outputHashAlgo = "sha256";
    });

    ventex = prev.fetchFromGitHub {
      owner = "vgskye";
      repo = "ventex";
      rev = "158c14e7d88acb140a71766c514d8a3724d260cd";
      hash = "sha256-Svc8dI2weFcqPSk064t/pL/4Hopn6/mWP6cIrT+FIr8=";
    };

    postConfigure = ''
      cp -r ${ventex} src/plugins/ventex
    '';
  });
}
