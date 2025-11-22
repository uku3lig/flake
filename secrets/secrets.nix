let
  fuji = "age16ujdfcahmnhe4ygruf28n0urgxycv8zgsp4f8856a5suewhn49cs0mqk7w";
  kilimandjaro = "age1ny0re542mcvf829y28rz6eta9myaqlxasfnn933srw64dlgavpsqc59q79";
  mottarone = "age1gfqwnjaajztwu72j8j6f5drdgupkvghsafzma4305pk95spf6u8q5e6zs8";
  etna = "age1m3jm6c5ywc5zntv5j4xhals0h28mpea88zzddq88zxcshmhteqwqu89qnh";
  vesuvio = "age1g2z0tztrv2w7wtludjrd85q7px3lvjms0cjj32zej9dqpjwpscwsle6xhf";

  main = [
    fuji
    kilimandjaro
    mottarone
  ];
  all = main ++ [
    etna
    vesuvio
  ];
in
{
  "shared/userPassword.age".publicKeys = all;
  "shared/frpToken.age".publicKeys = all;
  "shared/vmAuthToken.age".publicKeys = all;

  "fuji/rootPassword.age".publicKeys = main;
  "fuji-wsl/rootPassword.age".publicKeys = main;
  "kilimandjaro/rootPassword.age".publicKeys = main;
  "mottarone/rootPassword.age".publicKeys = main;
  "etna/rootPassword.age".publicKeys = main ++ [ etna ];
  "vesuvio/rootPassword.age".publicKeys = main ++ [ vesuvio ];

  "etna/tunnelCreds.age".publicKeys = main ++ [ etna ];
  "etna/apiRsEnv.age".publicKeys = main ++ [ etna ];
  "etna/ukubotRsEnv.age".publicKeys = main ++ [ etna ];
  "etna/minecraftEnv.age".publicKeys = main ++ [ etna ];
  "etna/dendriteKey.age".publicKeys = main ++ [ etna ];
  "etna/nextcloudAdminPass.age".publicKeys = main ++ [ etna ];
  "etna/turnstileSecret.age".publicKeys = main ++ [ etna ];
  "etna/navidromeEnv.age".publicKeys = main ++ [ etna ];
  "etna/forgejoRunnerSecret.age".publicKeys = main ++ [ etna ];
  "etna/forgejoMailerPasswd.age".publicKeys = main ++ [ etna ];
  "etna/vaultwardenEnv.age".publicKeys = main ++ [ etna ];
  "etna/vmauthEnv.age".publicKeys = main ++ [ etna ];
  "etna/upsdUserPass.age".publicKeys = main ++ [ etna ];
  "etna/cobaltTokens.age".publicKeys = main ++ [ etna ];
  "etna/slskdEnv.age".publicKeys = main ++ [ etna ];
  "etna/reposiliteDbPass.age".publicKeys = main ++ [ etna ];
  "etna/ziplineEnv.age".publicKeys = main ++ [ etna ];
  "etna/borgSshKey.age".publicKeys = main ++ [ etna ];
  "etna/borgPassphrase.age".publicKeys = main ++ [ etna ];
  "etna/synapseSigningKey.age".publicKeys = main ++ [ etna ];
  "etna/synapseExtraConfig.age".publicKeys = main ++ [ etna ];
  "etna/paperlessEnv.age".publicKeys = main ++ [ etna ];

  "vesuvio/gatusEnv.age".publicKeys = main ++ [ vesuvio ];
  "vesuvio/maddyEnv.age".publicKeys = main ++ [ vesuvio ];
  "vesuvio/rspamdPassword.age".publicKeys = main ++ [ vesuvio ];
  "vesuvio/roundcubeDbPass.age".publicKeys = main ++ [ vesuvio ];
  "vesuvio/nitterAccounts.age".publicKeys = main ++ [ vesuvio ];
  "vesuvio/pocketIdEnv.age".publicKeys = main ++ [ vesuvio ];
}
