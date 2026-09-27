{
  lib,
  stdenv,
  intellij-idea,
  makeWrapper,
  symlinkJoin,
  alsa-lib,
  esbuild,
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
  vulkan-loader,
  xrandr,
}:
symlinkJoin {
  name = "idea-wrapped-${intellij-idea.version}";

  paths = [ intellij-idea ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild =
    let
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
        vulkan-loader

        udev # oshi
        flite # tts
      ];

      runtimePrograms = [
        mesa-demos
        pciutils # need lspci
        xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
        esbuild
      ];
    in
    ''
      wrapProgram $out/bin/${intellij-idea.meta.mainProgram} \
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs} \
        --prefix PATH : ${lib.makeBinPath runtimePrograms}
    '';
}
