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

  dms-shell = prev.dms-shell.overrideAttrs {
    version = "1.2.3-unstable-2026-02-04";

    src = prev.fetchFromGitHub {
      owner = "AvengeMedia";
      repo = "DankMaterialShell";
      rev = "fe156679866fd5633a2c2a70c765410c22ee356a";
      hash = "sha256-9VFJof+LHB74dC0ZHEhsQf4TTFECQm2hNbR3PC6xrjk=";
    };

    vendorHash = "sha256-vsfCgpilOHzJbTaJjJfMK/cSvtyFYJsPDjY4m3iuoFg=";
  };
}
