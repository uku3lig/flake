{
  lib,
  stdenv,
  jetbrains,
  makeWrapper,
  symlinkJoin,
  alsa-lib,
  flite,
  glfw3-minecraft,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrandr,
  libXxf86vm,
  libjack2,
  libpulseaudio,
  mesa-demos,
  openal,
  pciutils,
  pipewire,
  udev,
  xrandr,
}: let
  inherit (jetbrains) idea-ultimate;
in
  symlinkJoin {
    name = "idea-ultimate-fixed-${idea-ultimate.version}";

    paths = [idea-ultimate];

    nativeBuildInputs = [makeWrapper];

    postBuild = let
      runtimeLibs = [
        stdenv.cc.cc.lib
        ## native versions
        glfw3-minecraft
        openal

        ## openal
        alsa-lib
        libjack2
        libpulseaudio
        pipewire

        ## glfw
        libGL
        libX11
        libXcursor
        libXext
        libXrandr
        libXxf86vm

        udev # oshi
        flite # tts
      ];

      runtimePrograms = [
        mesa-demos
        pciutils # need lspci
        xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      ];
    in ''
      wrapProgram $out/bin/idea-ultimate \
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs} \
        --prefix PATH : ${lib.makeBinPath runtimePrograms}
    '';
  }
