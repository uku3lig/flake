inputs: final: prev: {
  svn2git = prev.svn2git.overrideAttrs (_: rec {
    version = "2.4.2";

    src = prev.fetchFromGitHub {
      owner = "uku3lig";
      repo = "svn2git";
      rev = "v${version}";
      hash = "sha256-9uuiATFOLr1vDJDuV8J8yIqO3ENEgOOP45JBnghMyJk=";
    };
  });

  idea-ultimate-fixed = prev.callPackage ./idea-fixed.nix {};

  vencord = prev.vencord.overrideAttrs (old: rec {
    version = "${old.version}+git.${inputs.vencord.shortRev}";
    src = inputs.vencord;

    env =
      old.env
      // {
        VENCORD_REMOTE = "Vendicated/Vencord";
        VENCORD_HASH = src.shortRev;
      };

    pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
      outputHash = "sha256-vVzERis1W3QZB/i6SQR9dQR56yDWadKWvFr+nLTQY9Y=";
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

  fishPlugins = prev.fishPlugins.overrideScope (sfinal: sprev: {
    hydro = sprev.hydro.overrideAttrs (old: {
      version = "0-unstable-${inputs.hydro.lastModifiedDate}";
      src = inputs.hydro;
    });
  });
}
