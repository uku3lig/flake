{
  lib,
  buildGoModule,
  fetchFromGitHub,
  memos,
}:
buildGoModule (finalAttrs: {
  pname = "mortis";
  inherit (memos) version;

  src = fetchFromGitHub {
    owner = "mudkipme";
    repo = "mortis";
    tag = finalAttrs.version;
    hash = "sha256-Bc8B2418GsHURzxonNU96l0/3KVMx3YN7foTSF9aRyY=";
  };

  vendorHash = "sha256-jWCMogbATyn4hJD2Vi0B+pYuGS4YBAjz8tJI9hXcKC4=";

  meta = {
    license = lib.licenses.mit;
    mainProgram = "mortis";
  };
})
