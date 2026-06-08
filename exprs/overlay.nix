inputs: final: prev: {
  idea-wrapped = prev.callPackage ./idea-wrapped.nix { };
  pycharm-wrapped = prev.callPackage ./pycharm-wrapped.nix { };

  urbackup-client = prev.urbackup-client.overrideAttrs (
    f: p: {
      version = "2.5.30";

      src = prev.fetchzip {
        url = "https://hndl.urbackup.org/Client/${f.version}/urbackup-client-${f.version}.tar.gz";
        sha256 = "sha256-Bm9GTIR0tyK0Y7uj7akQFK0phL+OCuqdky22iyCmF7o=";
      };

      nativeBuildInputs = p.nativeBuildInputs or [ ] ++ [ final.autoreconfHook ];

      patches = p.patches or [ ] ++ [ ./urbackup-client-install.patch ];

      configureFlags = p.configureFlags or [ ] ++ [
        "--localstatedir=/var/lib"
      ];
    }
  );
}
