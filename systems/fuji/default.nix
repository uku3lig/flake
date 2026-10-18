{
  pkgs,
  config,
  username,
  camascaPkgs,
  ritornello,
  topinambour,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    ./nvidia.nix
    ../../programs/kde.nix
    ../../programs/jay
    ../../programs/games.nix
  ];

  environment.systemPackages = with pkgs; [
    camascaPkgs.girlglock-input-overlay
    picard
    qbittorrent
    ritornello.packages.${system}.ritornello
    ryubing
    topinambour.packages.${system}.topinambour
    wineWow64Packages.waylandFull
  ];

  hardware.bluetooth.enable = true;

  networking = {
    # managed by networkd
    useDHCP = false;
    networkmanager.enable = false;

    interfaces.enp12s0.wakeOnLan.enable = true;
  };

  services = {
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };

    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
      authentication = ''
        local all postgres peer
        local all ${username} peer
        local all all md5
      '';
    };

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1532", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="19f5", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="352d", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="3434", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="362d", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="373b", MODE="0660", GROUP="input"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="372e", MODE="0660", GROUP="input"
    '';

    moonshine = {
      enable = true;
      user = username;

      firewallInterfaces = [
        "enp12s0"
        "tailscale0"
      ];

      extraPackages = [ config.programs.steam.package ];

      settings = {
        name = "fuji";
        address = "0.0.0.0";
        application = [
          {
            title = "Steam";
            steam_integration = true;
            command = [
              "steam"
              "steam://open/bigpicture"
            ];
          }
        ];
      };
    };
  };

  systemd.network = {
    enable = true;
    networks."30-enp12s0" = {
      matchConfig.Name = "enp12s0";
      networkConfig.DHCP = "yes";
    };
  };

  programs.waywall = {
    width = 3840;
    height = 2160;
  };
}
