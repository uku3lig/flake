final: prev: {
  svn2git = prev.svn2git.overrideAttrs (_: rec {
    version = "2.4.1";

    src = prev.fetchFromGitHub {
      owner = "uku3lig";
      repo = "svn2git";
      rev = "v${version}";
      hash = "sha256-63q8UHHweTyN85imTKdDZjNmYlYMuxQx/SuF9KMgYbs=";
    };
  });
}
