let
  keys = {
    fuji = "age16ujdfcahmnhe4ygruf28n0urgxycv8zgsp4f8856a5suewhn49cs0mqk7w";
    fuji-wsl = "age16ujdfcahmnhe4ygruf28n0urgxycv8zgsp4f8856a5suewhn49cs0mqk7w"; # same as fuji
    kilimandjaro = "age1ny0re542mcvf829y28rz6eta9myaqlxasfnn933srw64dlgavpsqc59q79";
    mottarone = "age1gfqwnjaajztwu72j8j6f5drdgupkvghsafzma4305pk95spf6u8q5e6zs8";
    etna = "age1m3jm6c5ywc5zntv5j4xhals0h28mpea88zzddq88zxcshmhteqwqu89qnh";
    vesuvio = "age1g2z0tztrv2w7wtludjrd85q7px3lvjms0cjj32zej9dqpjwpscwsle6xhf";
  };

  main = [
    keys.fuji
    keys.kilimandjaro
    keys.mottarone
  ];

  all = builtins.attrValues keys;

  # from nixpkgs/lib/lists.nix
  uniqueStrings = list: builtins.attrNames (builtins.groupBy (e: e) list);

  mkSecretList =
    l:
    builtins.concatLists (
      builtins.attrValues (builtins.mapAttrs (dir: files: map (file: { inherit dir file; }) files) l)
    );

  mkSecrets =
    l:
    builtins.listToAttrs (
      map (
        { dir, file }:
        {
          name = "${dir}/${file}.age";
          value = {
            publicKeys = uniqueStrings (if dir == "shared" then all else main ++ [ keys.${dir} ]);
            armor = true;
          };
        }
      ) (mkSecretList l)
    );

in
mkSecrets {
  shared = [
    "frpToken"
    "userPassword"
    "vmAuthToken"
  ];

  fuji = [ "rootPassword" ];
  fuji-wsl = [ "rootPassword" ];
  kilimandjaro = [ "rootPassword" ];
  mottarone = [ "rootPassword" ];

  etna = [
    "rootPassword"
    "apiRsEnv"
    "borgPassphrase"
    "borgSshKey"
    "cobaltTokens"
    "dendriteKey"
    "forgejoMailerPasswd"
    "forgejoRunnerSecret"
    "grafanaKey"
    "minecraftEnv"
    "navidromeEnv"
    "nextcloudAdminPass"
    "paperlessEnv"
    "reposiliteDbPass"
    "slskdEnv"
    "synapseExtraConfig"
    "synapseSigningKey"
    "tunnelCreds"
    "turnstileSecret"
    "ukubotTsEnv"
    "upsdUserPass"
    "vaultwardenEnv"
    "vmauthEnv"
    "ziplineEnv"
  ];

  vesuvio = [
    "rootPassword"
    "gatusEnv"
    "maddyEnv"
    "nitterAccounts"
    "pocketIdEnv"
    "roundcubeDbPass"
    "rspamdPassword"
  ];
}
