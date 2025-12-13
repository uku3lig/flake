{ lib, pkgs, ... }:
{
  setupSecrets =
    _config:
    {
      secrets,
      extra ? { },
    }:
    let
      inherit (_config.networking) hostName;
    in
    {
      generate = {
        age.secrets = lib.genAttrs secrets (name: extra // { file = ../secrets/${hostName}/${name}.age; });
      };
      get = name: _config.age.secrets.${name}.path;
    };

  setupSingleSecret =
    _config: name: extra:
    let
      inherit (_config.networking) hostName;
    in
    {
      generate = {
        age.secrets.${name} = extra // {
          file = ../secrets/${hostName}/${name}.age;
        };
      };
      inherit (_config.age.secrets.${name}) path;
    };

  setupSharedSecrets =
    _config:
    {
      secrets,
      extra ? { },
    }:
    {
      generate = {
        age.secrets = lib.genAttrs secrets (name: extra // { file = ../secrets/shared/${name}.age; });
      };
      get = name: _config.age.secrets.${name}.path;
    };

  mkMinecraftServer =
    _config:
    {
      name,
      port,
      remotePort,
      tag ? "java21",
      dataDir ? "/var/lib/${name}",
      memory ? "4G",
      env ? { },
      envFiles ? [ ],
      extraPorts ? [ ],
    }:
    let
      inherit (_config.virtualisation.oci-containers) backend;
    in
    {
      virtualisation.oci-containers.containers."mc-${name}" = {
        image = "itzg/minecraft-server:${tag}";
        ports = [ "${builtins.toString port}:25565" ] ++ extraPorts;
        volumes = [ "${dataDir}:/data" ];
        environmentFiles = envFiles;
        environment = {
          EULA = "true";
          MEMORY = memory;
        }
        // env;
      };

      networking.firewall.allowedTCPPorts = [ port ];

      services.frp.instances.default.settings.proxies = [
        {
          inherit name remotePort;
          type = "tcp";
          localIp = "127.0.0.1";
          localPort = port;
        }
      ];

      systemd.services."${backend}-mc-${name}".serviceConfig.TimeoutSec = "300";
    };

  mkFrpPassthrough = name: port: {
    services.frp.settings.proxies = [
      {
        inherit name;
        type = "tcp";
        localIp = "localhost";
        localPort = port;
        remotePort = port;
      }
    ];
  };

  # shamelessly stolen from soopyc's gensokyo
  mkNginxFile =
    {
      filename ? "index.html",
      content,
      status ? 200,
    }:
    {
      # gets the store path of the directory in which the file is contained
      # we have to use writeTextDir because we don't want to expose the whole nix store to nginx
      # and because you can't just return an absolute path to a file
      alias = builtins.toString (pkgs.writeTextDir filename content) + "/";
      tryFiles = "${filename} =${builtins.toString status}";
    };

  # https://github.com/nix-community/home-manager/blob/ec71b5162848e6369bdf2be8d2f1dd41cded88e8/modules/lib/generators.nix#L4-L61
  toHyprconf =
    attrs:
    let
      inherit (lib)
        all
        concatMapStringsSep
        concatStrings
        concatStringsSep
        filterAttrs
        foldl
        generators
        hasPrefix
        isAttrs
        isList
        mapAttrsToList
        replicate
        ;

      indentLevel = 0;
      importantPrefixes = [ "$" ];
      initialIndent = concatStrings (replicate indentLevel "  ");

      toHyprconf' =
        indent: attrs:
        let
          sections = filterAttrs (n: v: isAttrs v || (isList v && all isAttrs v)) attrs;

          mkSection =
            n: attrs:
            if lib.isList attrs then
              (concatMapStringsSep "\n" (a: mkSection n a) attrs)
            else
              ''
                ${indent}${n} {
                ${toHyprconf' "  ${indent}" attrs}${indent}}
              '';

          mkFields = generators.toKeyValue {
            listsAsDuplicateKeys = true;
            inherit indent;
          };

          allFields = filterAttrs (n: v: !(isAttrs v || (isList v && all isAttrs v))) attrs;

          isImportantField =
            n: _: foldl (acc: prev: if hasPrefix prev n then true else acc) false importantPrefixes;

          importantFields = filterAttrs isImportantField allFields;

          fields = builtins.removeAttrs allFields (mapAttrsToList (n: _: n) importantFields);
        in
        mkFields importantFields
        + concatStringsSep "\n" (mapAttrsToList mkSection sections)
        + mkFields fields;
    in
    toHyprconf' initialIndent attrs;
}
