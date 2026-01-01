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
      version = "0.2025.12.30";

      src = prev.fetchFromGitHub {
        owner = "tesselslate";
        repo = "waywall";
        tag = f.version;
        hash = "sha256-idtlOXT3RGjAOMgZ+e5vwZnxd33snc4sIjq0G6TU7HU=";
      };

      nativeBuildInputs = p.nativeBuildInputs ++ [ prev.makeWrapper ];

      postInstall = ''
        wrapProgram $out/bin/waywall --prefix PATH : ${prev.lib.makeBinPath [ prev.xwayland ]}
      '';
    }
  );
}
