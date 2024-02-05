final: prev: {
  electron_25 = prev.electron_25.overrideAttrs (_: {
    preFixup = "patchelf --add-needed ${prev.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
    meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
  });

  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge.nix {
    inherit (prev.pkgsCross.mingw32) stdenv;
  };

  wayland-protocols-explicit-sync = prev.wayland-protocols.overrideAttrs (_: {
    version = "1.33-explicit-sync";

    patches = [
      (prev.fetchurl {
        url = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/90.patch";
        hash = "sha256-EFCnJLl7a41YAENh7wLdk0VtJIbzg7LCbMiYqqUHy7A=";
      })
    ];
  });

  wlroots-explicit-sync =
    (prev.wlroots.override (_: {wayland-protocols = final.wayland-protocols-explicit-sync;})).overrideAttrs
    (old: {
      version = "0.18.0-explicit-sync";

      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "emersion";
        repo = "wlroots";
        rev = "dc8ff13a109bacd66a99b1f8b58865ff23d2715c";
        hash = "sha256-QGpdOr63lOTecyqfZavzJA8HYpB9LxiSQRAh94PDOK0=";
      };

      patches = [
        ./explicit-sync/4262.patch
      ]; # don't inherit old.patches

      pname = "${old.pname}-hyprland";
    });

  xorgproto-explicit-sync = prev.xorg.xorgproto.overrideAttrs (old: {
    version = "2023.2-explicit-sync";

    patches = [
      (prev.fetchurl {
        url = "https://gitlab.freedesktop.org/xorg/proto/xorgproto/-/merge_requests/59.patch";
        hash = "sha256-p+9Gc3aM1RKlB9EinDw7qeSEQOAnXErygMRKTgJZk3o=";
      })
    ];
  });

  xwayland = (prev.xwayland.override (_: {
      xorgproto = final.xorgproto-explicit-sync;
      wayland-protocols = final.wayland-protocols-explicit-sync;
    }))
    .overrideAttrs (old: {
      version = "23.2.4-explicit-sync";

      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "xorg";
        repo = "xserver";
        rev = "a8bb924af19f8666a39db2cf50b0c7f00564db06";
        hash = "sha256-yEzk+kw+kRJFG2qBqHPQBeNE9shLv+at+wyIGQLyNss=";
      };

      patches = [
        # ./explicit-sync/967.patch
        (prev.fetchurl {
          url = "https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/967.patch";
          hash = "sha256-DhQ1VhS8Rg3h9kPnyq8cAvdAcJI1M++dHJQvDeBR/Zw=";
        })
      ];

      buildInputs = [final.xorgproto-explicit-sync prev.systemd prev.xorg.libpciaccess] ++ old.buildInputs;
    });

  hyprland = prev.hyprland.override (_: {
    # wlroots = final.wlroots-explicit-sync;
    # xwayland = final.xwayland-explicit-sync;
  });
}
