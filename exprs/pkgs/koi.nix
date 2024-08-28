{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  wrapQtAppsHook,
  qtbase,
  qtwayland,
  kcoreaddons,
  kwidgetsaddons,
  kconfig,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "koi";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "baduhai";
    repo = "Koi";
    rev = finalAttrs.version;
    hash = "sha256-dhpuKIY/Xi62hzJlnVCIOF0k6uoQ3zH129fLq/r+Kmg=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [cmake ninja wrapQtAppsHook];
  buildInputs = [qtbase qtwayland kcoreaddons kwidgetsaddons kconfig];
})
