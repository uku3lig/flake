{
  lib,
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = [ pkgs.waybar ];

  hj = {
    ".config/waybar/style.css".source = ./style.css;

    ".config/waybar/config".text = builtins.toJSON {
      position = "bottom";
      layer = "top";
      height = 24;
      spacing = 2;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ ];
      modules-right =
        [ "memory" ]
        ++ lib.optionals (builtins.elem "amdgpu" config.services.xserver.videoDrivers) [
          "custom/gpu-usage"
        ]
        ++ [
          "cpu"
          "wireplumber"
        ]
        ++ lib.optionals config.services.power-profiles-daemon.enable [ "battery" ]
        ++ lib.optionals config.programs.light.enable [ "backlight" ]
        ++ [
          "clock"
          "tray"
        ];

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
      };

      tray = {
        icon-size = 16;
        spacing = 10;
      };

      clock = {
        format-alt = "{:%Y-%m-%d %H:%M:%S}";
        interval = 1;
      };

      cpu = {
        format = "CPU {usage}%";
        tooltip = false;
        interval = 2;
      };

      memory = {
        format = "RAM {}%";
        interval = 2;
      };

      backlight = {
        format = "LGT {percent}%";
        scroll-step = 5;
      };

      battery = {
        states = {
          low = 15;
        };
        format = "BAT {capacity}%";
        format-charging = "BAT+ {capacity}%";
        format-plugged = "BAT+ {capacity}%";
        format-low = "BAT! {capacity}%";
        interval = 5;
      };

      wireplumber = {
        scroll-step = 5;
        format = "VOL {volume}%";
        format-muted = "muted";
        on-click = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "${lib.getExe pkgs.pavucontrol}";
      };

      "custom/gpu-usage" = {
        exec = "cat /sys/class/hwmon/hwmon*/device/gpu_busy_percent";
        format = "GPU {}%";
        return-type = "";
        interval = 2;
      };
    };
  };
}
