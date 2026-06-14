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
    hash = "sha256-hX04mvQ2C0kEBRObaKli+0YmL1cd1suPw5TV5/XIIlc=";
  };

  vendorHash = "sha256-UVC6rHW6PFUiZW7QhmIqam5csZyM5ng4IMmM97sbFJA=";

  meta = {
    license = lib.licenses.mit;
    mainProgram = "mortis";
  };
})
