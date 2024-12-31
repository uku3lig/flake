{ lib, pkgs, ... }:
{
  environment.sessionVariables = {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/ssh-agent";
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  systemd.user.services.ssh-agent = {
    wantedBy = [ "default.target" ];
    environment.SSH_AUTH_SOCK = "%t/ssh-agent";
    script = "${lib.getExe' pkgs.openssh "ssh-agent"} -d -a $SSH_AUTH_SOCK";
  };
}
