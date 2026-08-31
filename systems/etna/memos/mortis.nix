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
    hash = "sha256-KuOdbOq8bsDzGLI6VdDiZMQkVkkwgwPpM4KM+39J/7w=";
  };

  vendorHash = "sha256-UVC6rHW6PFUiZW7QhmIqam5csZyM5ng4IMmM97sbFJA=";

  meta = {
    license = lib.licenses.mit;
    mainProgram = "mortis";
  };
})
