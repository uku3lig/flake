{ config, ... }:
{
  services = {
    openssh = {
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

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "netbios name" = "etna";
          "server string" = "Samba %v on %h";
          "map to guest" = "Bad User";
          "hosts allow" = "192.168.1. 100. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
        };

        share1 = {
          path = "/data/storage";
          browsable = "yes";
          "guest ok" = "no";
          "read only" = "no";
          "create mask" = "0755";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    borgbackup.jobs.share = config.passthru.makeBorg "share" "/data/storage";
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
