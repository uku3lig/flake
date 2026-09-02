{
  lib,
  pkgs,
  username,
  camascaPkgs,
  ...
}:
{
  imports = [
    ../../programs/gnome.nix
    ./urbackup.nix
  ];

  boot.blacklistedKernelModules = [ "kvm_intel" ];

  environment.systemPackages = with pkgs; [
    apache-directory-studio
    camascaPkgs.jaspersoft-studio-community
    camascaPkgs.openwebstart
    camascaPkgs.sql-developer
    gnomeExtensions.solaar-extension
    hoppscotch
    nagstamon
    pycharm-wrapped
    remmina
  ];

  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
  ];

  i18n.defaultLocale = lib.mkForce "fr_FR.UTF-8";

  hj = {
    ".gitconfig".text = lib.mkAfter (
      lib.generators.toGitINI {
        include.path = "~/.config/git/work_config";
      }
    );

    ".ssh/config".text = lib.mkBefore ''
      Include work_config
    '';
  };

  hardware.logitech.wireless.enable = true;

  networking = {
    firewall.allowedTCPPorts = [ 8000 ];
    networkmanager = {
      plugins = [ pkgs.networkmanager-openconnect ];
      dispatcherScripts = [
        {
          type = "basic";
          source = pkgs.writeShellScript "vpnUpHook" ''
            if [ "$2" == "vpn-up" ]; then
              resolvectl default-route tun0 true
              logger "Set default-route to tun0"
            fi
          '';
        }
      ];
    };
  };

  programs = {
    nix-ld.enable = true;
    solaar.enable = true;
  };

  services = {
    glpiAgent = {
      enable = true;
      settings = {
        server = "https://assistance.sciencespo-lyon.fr";
        delaytime = 3600;
        lazy = 0;
        logger = "stderr";
      };
    };

    postgresql = {
      enable = true;
      authentication = ''
        local all postgres peer
        local all ${username} peer
        local all all md5
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /opt/liberica-17 - - - - ${camascaPkgs.liberica-17}"
    "r /home/${username}/Downloads/*.jnlp"
  ];

  programs.virt-manager.enable = lib.mkForce false;
  virtualisation.libvirtd.enable = lib.mkForce false;
}
