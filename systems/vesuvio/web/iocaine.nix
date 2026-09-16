{ pkgs, ... }:
let
  # https://git.madhouse-project.org/iocaine/-/packages/generic/nam-shub-of-enki/iocaine-3.x
  nsoe = pkgs.fetchzip {
    url = "https://git.madhouse-project.org/iocaine/-/packages/generic/nam-shub-of-enki/iocaine-3.x/files/14114";
    extension = "tar.zst";
    nativeBuildInputs = [ pkgs.zstd ];
    hash = "sha256-wukbjGpULsjhuOiU5sMuPcmcoF27wo3BhRsFKg4tctg=";
  };
in
{
  services.iocaine = {
    enable = true;
    settings = {
      server = {
        default = {
          bind = "/run/iocaine/default.sock";
          unix-socket-access = "group";
          mode = "http";
          use = {
            handler-from = "nsoe";
            metrics = "metrics";
          };
        };

        metrics = {
          bind = "[::]:42042";
          mode = "prometheus";
        };
      };

      handler.nsoe = {
        path = nsoe;
        language = "roto";
        config = {
          inherits = "recommended";
          sources = {
            "training-corpus" = [
              "/etc/iocaine/data/corpus/1984.txt"
              "/etc/iocaine/data/corpus/l-etranger.txt"
              "/etc/iocaine/data/corpus/les-miserables.txt"
            ];
            "wordlists" = "/etc/iocaine/data/corpus/words.txt";
          };
        };
      };
    };
  };

  services.nginx.upstreams = {
    iocaine.servers."unix:/run/iocaine/default.sock" = { };
  };
}
