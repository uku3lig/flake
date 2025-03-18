{
  stdenvNoCC,
  fetchzip,
  win2xcur,
}:
stdenvNoCC.mkDerivation {
  pname = "niigo-miku-cursors";
  version = "0";

  src = fetchzip {
    url = "https://www.colorfulstage.com/upload_images/media/Download/cur%20file-static-N25.zip";
    hash = "sha256-sx5sB1n5eQurZr+DsAFWKNblfGxHt5RBWluc2ChkYsM=";
    stripRoot = false;
  };

  nativeBuildInputs = [ win2xcur ];

  buildPhase = ''
    mkdir output/
    win2xcur *.{ani,cur} -o output

    pushd output
    mv Busy wait
    mv Diagonal1 size_fdiag
    mv Diagonal2 size_bdiag
    mv Help help
    mv Horizontal ew-resize
    mv Link pointer
    mv Move move
    mv Normal default
    mv Precision cross
    mv Text text
    mv Unavailable not-allowed
    mv Vertical ns-resize
    mv Working half-busy

    bash ${./addmissing.sh}
    popd
  '';

  installPhase = ''
    mkdir -p "$out/share/icons/N25 Miku/cursors"
    cp output/{*,.*} "$out/share/icons/N25 Miku/cursors"

    echo -e "[Icon Theme]\nName=N25 Miku" > "$out/share/icons/N25 Miku/index.theme"
    echo -e "[Icon Theme]\nInherits=N25 Miku" > "$out/share/icons/N25 Miku/cursor.theme"
  '';
}
