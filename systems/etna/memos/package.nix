{
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  lib,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
}:
buildGoModule (finalAttrs: {
  pname = "memos";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HEQeMsUVvmrnW3pvTzMGIlCl8B9UuwnlyU8U0r1aRSc=";
  };

  vendorHash = "sha256-QNJosdRo1DauCOGFB+GrasSoKSmRhc3EjRfjm4TG0Jo=";

  memos-web = stdenvNoCC.mkDerivation (finalAttrsWeb: {
    pname = "memos-web";
    inherit (finalAttrs) version src;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrsWeb) pname version src;
      sourceRoot = "${finalAttrsWeb.src.name}/web";
      fetcherVersion = 3;
      hash = "sha256-fo8ACqY7RwbCfwkc9vxiKDARse/89ydpm3WcnP3tuEo=";
    };

    pnpmRoot = "web";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      runHook preBuild
      pnpm -C web build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r web/dist $out
      runHook postInstall
    '';
  });

  postPatch = ''
    sed -i 's/"dev"/"${finalAttrs.version}"/' internal/version/version.go
  '';

  preBuild = ''
    rm -rf server/router/frontend/dist
    cp -r ${finalAttrs.memos-web} server/router/frontend/dist
  '';

  passthru = {
    inherit (finalAttrs) memos-web;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "memos-web"
      ];
    };
  };

  doCheck = false;

  meta = {
    homepage = "https://usememos.com";
    description = "Lightweight, self-hosted memo hub";
    changelog = "https://github.com/usememos/memos/releases/tag/${finalAttrs.src.rev}";
    maintainers = with lib.maintainers; [
      indexyz
      kuflierl
    ];
    license = lib.licenses.mit;
    mainProgram = "memos";
  };
})
