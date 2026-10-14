{ lib, pkgs, ... }:
let
  # broken with latest beets, so we use a fork
  beets-filetote = pkgs.python3Packages.beets-filetote.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "treyturner";
      repo = "beets-filetote";
      rev = "6c182af870a495d55052d8520c8ff501b0010947";
      hash = "sha256-u743aXP6b6TOLKiJACrFFyJB49eAQb0k1cJ1TOfqBqY=";
    };

    meta.broken = false;
  };

  beets = pkgs.python3.pkgs.beets.override {
    pluginOverrides = {
      filetote = {
        enable = true;
        propagatedBuildInputs = [ beets-filetote ];
      };
    };
  };
in
{
  environment.systemPackages = [ beets ];

  services.jellyfin = {
    enable = true;
    dataDir = "/var/lib/jellyfin";
  };

  hj.".config/beets/config.yaml" = {
    generator = lib.generators.toYAML { };
    value = {
      directory = "/data/music";
      library = "/data/music/.beets/beets.db";

      import = {
        move = "yes";
        write = "yes";
      };

      plugins = [
        "fish" # completions [beet fish]
        "musicbrainz" # get metadata from mb
        "badfiles" # check for corrupted files [beet bad]
        "web" # webui for browsing [beet web]
        "edit" # edit data of files and albums [beet edit]
        "filetote" # import extra files
      ];

      paths = {
        comp = "$albumartist/$album%aunique{}/$track $title";
        default = "$albumartist/$album%aunique{}/$track $title";
        singleton = "$artist/$title%sunique{}/$title";
      };

      # plugin configs
      badfiles.check_on_import = "yes";
      filetote.extensions = ".*";
    };
  };
}
