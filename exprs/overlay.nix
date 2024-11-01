vencord-input: final: prev: {
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

  vencord = prev.vencord.overrideAttrs (old: {
    src =
      vencord-input
      // {
        owner = "Vendicated";
        repo = "Vencord";
      };

    patches = old.patches or [] ++ [./ventex.patch];
  });
}
