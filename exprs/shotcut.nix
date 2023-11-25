{
  lib,
  fetchFromGitHub,
  stdenv,
  wrapQtAppsHook,
  SDL2,
  frei0r,
  ladspaPlugins,
  gettext,
  mlt,
  jack1,
  pkg-config,
  fftw,
  qtbase,
  qttools,
  qtmultimedia,
  qtcharts,
  cmake,
  gitUpdater,
}:
assert lib.versionAtLeast mlt.version "7.18.0";
  stdenv.mkDerivation rec {
    pname = "shotcut";
    version = "23.11.04";

    src = fetchFromGitHub {
      owner = "mltframework";
      repo = "shotcut";
      rev = "v${version}";
      hash = "sha256-0T/0gqW86enTO2OkmxiDF/kWPHILjRSNU2rufNJdVOg=";
    };

    nativeBuildInputs = [pkg-config cmake wrapQtAppsHook];
    buildInputs = [
      SDL2
      frei0r
      ladspaPlugins
      gettext
      mlt
      fftw
      qtbase
      qttools
      qtmultimedia
      qtcharts
    ];

    env.NIX_CFLAGS_COMPILE = "-DSHOTCUT_NOUPGRADE";
    cmakeFlags = [
      "-DSHOTCUT_VERSION=${version}"
    ];

    prePatch = ''
      sed 's_shotcutPath, "melt[^"]*"_"${mlt}/bin/melt"_' -i src/jobs/meltjob.cpp
      sed 's_shotcutPath, "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/jobs/ffmpegjob.cpp
      sed 's_qApp->applicationDirPath(), "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/docks/encodedock.cpp
      NICE=$(type -P nice)
      sed "s_/usr/bin/nice_''${NICE}_" -i src/jobs/meltjob.cpp src/jobs/ffmpegjob.cpp
    '';

    qtWrapperArgs = [
      "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
      "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"
      "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [jack1 SDL2]}"
      "--prefix PATH : ${mlt}/bin"
    ];

    passthru.updateScript = gitUpdater {
      rev-prefix = "v";
    };

    meta = with lib; {
      description = "A free, open source, cross-platform video editor";
      longDescription = ''
        An official binary for Shotcut, which includes all the
        dependencies pinned to specific versions, is provided on
        http://shotcut.org.

        If you encounter problems with this version, please contact the
        nixpkgs maintainer(s). If you wish to report any bugs upstream,
        please use the official build from shotcut.org instead.
      '';
      homepage = "https://shotcut.org";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [goibhniu woffs peti];
      platforms = platforms.linux;
    };
  }
