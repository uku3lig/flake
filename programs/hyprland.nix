{
  lib,
  pkgs,
  ...
}: {
  programs.hyprland.enable = true;

  hm = {
    home.packages = with pkgs; [
      hyprpaper
      hyprpicker
      wl-clipboard
      cliphist
      swayidle
      swappy
      grimblast
      playerctl
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = let
        inherit (lib) getExe getExe';
        keys = ["ampersand" "eacute" "quotedbl" "apostrophe" "parenleft" "minus" "egrave" "underscore" "ccedilla" "agrave"];
      in
        with pkgs; {
          "$mod" = "SUPER";
          "$wl-paste" = getExe' wl-clipboard "wl-paste";
          "$wpctl" = getExe' wireplumber "wpctl";

          monitor = ",highres,auto,1";

          env = [
            "WLR_DRM_NO_ATOMIC,1"
            "SDL_VIDEODRIVER,wayland"
            "MOZ_ENABLE_WAYLAND,1"
            "_JAVA_AWT_WM_NONREPARENTING,1"
            "NIXOS_OZONE_WL,1"
          ];

          exec-once = [
            "${getExe waybar}"
            "${getExe hyprpaper}"
            "${getExe swayidle} -w"
            "${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            "$wl-paste --type  text --watch ${getExe cliphist} store"
            "$wl-paste --type image --watch ${getExe cliphist} store"
          ];

          input = {
            kb_layout = "fr";
            follow_mouse = 1;

            touchpad.drag_lock = true;

            sensitivity = -0.1;
            accel_profile = "flat";
          };

          general = {
            gaps_in = 0;
            gaps_out = 0;
            border_size = 0;

            allow_tearing = true;
          };

          decoration = {
            drop_shadow = false;
            blur.enabled = true;
          };

          animations = {
            enabled = true;

            animation = [
              "windows, 1, 2, default"
              "windowsOut, 1, 2, default, popin 90%"
              "fade, 1, 2, default"
              "workspaces, 1, 3, default"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
          };

          gestures.workspace_swipe = true;

          windowrulev2 = [
            "float, class:^(pavucontrol)$"

            "nomaximizerequest, class:^(firefox)$"
            "float, title:^(Picture-in-Picture)$"
	    "float, class:^(firefox)$, title:^()$" # notifications

            "immediate, class:^(cs2)$"
            "immediate, class:^(osu.*)$"
            "immediate, class:^(steam_app_1229490)$" # ultrakill
            # "immediate, class:^(steam_app_\d+)$"
            # "immediate, class:^(steam_app_322170)$"
          ];

          bind =
            [
              "$mod, Return, exec, ${getExe alacritty}"
              "$mod SHIFT, A, killactive,"
              "$mod SHIFT, E, exit,"
              "$mod SHIFT, Space, togglefloating,"
              "$mod, D, exec, ${getExe fuzzel}"
              "$mod, F, fullscreen, 0"
              "$mod, P, pseudo," # dwindle
              "$mod, J, togglesplit," # dwindle

              # audio
              ",XF86AudioRaiseVolume, exec, $wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
              ",XF86AudioLowerVolume, exec, $wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ",XF86AudioMute, exec, $wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ",XF86AudioMicMute, exec, $wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ",XF86AudioPause, exec, ${getExe playerctl} play-pause"
              ",XF86AudioPlay, exec, ${getExe playerctl} play-pause"
              ",XF86AudioNext, exec, ${getExe playerctl} next"
              ",XF86AudioPrev, exec, ${getExe playerctl} previous"

              # backlight
              ",XF86MonBrightnessUp, exec, ${getExe' light "light"} -A 5"
              ",XF86MonBrightnessDown, exec, ${getExe' light "light"} -U 5"

              # screenshot
              ",Print, exec, ${getExe grimblast} --freeze save area - | ${getExe swappy} -f -"
            ]
            ++
            # Switch workspaces with mod + [0-9]
            # Move active window to a workspace with mod + SHIFT + [0-9]
            lib.flatten (builtins.map (i: let
              key = builtins.elemAt keys (i - 1);
            in [
              "$mod, ${key}, workspace, ${toString i}"
              "$mod SHIFT, ${key}, movetoworkspace, ${toString i}"
            ]) (lib.range 1 10));

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod SHIFT, mouse:272, resizewindow"
          ];
        };
    };
  };
}
