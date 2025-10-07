{ config, ... }:
{
  services.openssh = {
    allowSFTP = true;
    sftpServerExecutable = "internal-sftp";
    extraConfig = ''
      Match user storage
        ChrootDirectory /data
        AllowTcpForwarding no
        AllowAgentForwarding no
        ForceCommand internal-sftp -d /storage
    '';
  };

  users = {
    groups.storage = { };
    users.storage = {
      isSystemUser = true;
      group = "storage";
      openssh.authorizedKeys = config.users.users.leo.openssh.authorizedKeys;
    };
  };
}
