{
  pkgs,
  config,
  ...
}: {
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  age = {
    identityPaths = ["/etc/age/key"];

    secrets = let
      base = ../../secrets/vesuvio;
    in {
      rootPassword.file = "${base}/rootPassword.age";
      userPassword.file = "${base}/userPassword.age";

      apiEnv.file = "${base}/apiEnv.age";
    };
  };

  services = {
    openssh.enable = true;
  };

  virtualisation.oci-containers.containers = {
    reposilite = {
      image = "dzikoysk/reposilite:latest";
      ports = ["8080:8080"];
      volumes = ["/opt/reposilite-data:/app/data"];
    };
    vaultwarden = {
      image = "vaultwarden/server:latest";
      ports = ["3002:80"];
      volumes = ["/opt/vw-data:/data"];
    };
    api-rs = {
      image = "ghcr.io/uku3lig/api-rs:latest";
      ports = ["5000:5000"];
      environmentFiles = [config.age.secrets.apiEnv.path];
    };
  };

  console.keyMap = "fr";

  users.users = {
    uku = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8 uku3lig"];
      passwordFile = config.age.secrets.userPassword.path;
    };

    root.passwordFile = config.age.secrets.rootPassword.path;
  };

  system.stateVersion = "23.05";
}
