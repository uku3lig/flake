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

  idea-ultimate-fhs = prev.buildFHSEnv {
    name = "idea-ultimate";

    targetPkgs = pkgs: (with pkgs; [
      stdenv.cc.cc.lib
      glfw3-minecraft
      openal

      ## openal
      alsa-lib
      libjack2
      libpulseaudio
      pipewire

      ## glfw
      libGL
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr
      xorg.libXxf86vm

      udev # oshi
      flite
    ]);

    extraInstallCommands = ''
      ln -s "${prev.jetbrains.idea-ultimate}/share" "$out/"
    '';

    runScript = prev.lib.getExe prev.jetbrains.idea-ultimate;
  };
}
