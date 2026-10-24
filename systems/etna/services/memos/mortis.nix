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
    hash = "sha256-PB4OqBlgoIvoilIAH8G+QsRPbnlR3OLNfgOEonamiHc=";
  };

  vendorHash = "sha256-jWCMogbATyn4hJD2Vi0B+pYuGS4YBAjz8tJI9hXcKC4=";

  meta = {
    license = lib.licenses.mit;
    mainProgram = "mortis";
  };
})
