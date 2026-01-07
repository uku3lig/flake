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
      version = "0-unstable-2026-01-06";

      src = prev.fetchFromGitHub {
        owner = "tesselslate";
        repo = "waywall";
        rev = "c6504f95f8d757a2e060c4df8bd3ed145ad59e8d";
        hash = "sha256-kfBsppc+esz0Q6iIIKAeOMwkIWdN12AlH3Dji8bU32c=";
      };
    }
  );
}
