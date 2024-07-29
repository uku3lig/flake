{lib, ...}: {
  setupSecrets = _config: {
    secrets,
    extra ? {},
  }: let
    inherit (_config.networking) hostName;
  in {
    generate = {age.secrets = lib.genAttrs secrets (name: extra // {file = ../secrets/${hostName}/${name}.age;});};
    get = name: _config.age.secrets.${name}.path;
  };

  setupSingleSecret = _config: name: extra: let
    inherit (_config.networking) hostName;
  in {
    generate = {age.secrets.${name} = extra // {file = ../secrets/${hostName}/${name}.age;};};
    inherit (_config.age.secrets.${name}) path;
  };

  setupSharedSecrets = _config: {
    secrets,
    extra ? {},
  }: {
    generate = {age.secrets = lib.genAttrs secrets (name: extra // {file = ../secrets/shared/${name}.age;});};
    get = name: _config.age.secrets.${name}.path;
  };

  mkMinecraftServer = _config: {
    name,
    port,
    remotePort,
    tag ? "java21",
    dataDir ? "/var/lib/${name}",
    memory ? "4G",
    env ? {},
    envFiles ? [],
    extraPorts ? [],
  }: let
    inherit (_config.virtualisation.oci-containers) backend;
  in {
    virtualisation.oci-containers.containers.${name} = {
      image = "itzg/minecraft-server:${tag}";
      ports = ["${builtins.toString port}:25565"] ++ extraPorts;
      volumes = ["${dataDir}:/data"];
      environmentFiles = envFiles;
      environment =
        {
          EULA = "true";
          MEMORY = memory;
        }
        // env;
    };

    services.frp.settings.proxies = [
      {
        inherit name remotePort;
        type = "tcp";
        localIp = "127.0.0.1";
        localPort = port;
      }
    ];

    systemd.services."${backend}-${name}".serviceConfig.TimeoutSec = "300";
  };
}
