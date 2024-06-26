let
  fuji = "age16ujdfcahmnhe4ygruf28n0urgxycv8zgsp4f8856a5suewhn49cs0mqk7w";
  kilimandjaro = "age1ny0re542mcvf829y28rz6eta9myaqlxasfnn933srw64dlgavpsqc59q79";
  etna = "age1m3jm6c5ywc5zntv5j4xhals0h28mpea88zzddq88zxcshmhteqwqu89qnh";

  main = [fuji kilimandjaro];
  all = main ++ [etna];
in {
  "userPassword.age".publicKeys = all;
  "tailscaleKey.age".publicKeys = all;

  "fuji/rootPassword.age".publicKeys = main;
  "fuji-wsl/rootPassword.age".publicKeys = main;
  "kilimandjaro/rootPassword.age".publicKeys = main;

  "etna/rootPassword.age".publicKeys = main ++ [etna];
  "etna/tunnelCreds.age".publicKeys = main ++ [etna];
  "etna/apiRsEnv.age".publicKeys = main ++ [etna];
  "etna/ukubotRsEnv.age".publicKeys = main ++ [etna];
  "etna/minecraftEnv.age".publicKeys = main ++ [etna];
  "etna/dendriteKey.age".publicKeys = main ++ [etna];
  "etna/nextcloudAdminPass.age".publicKeys = main ++ [etna];
  "etna/frpToken.age".publicKeys = main ++ [etna];
  "etna/turnstileSecret.age".publicKeys = main ++ [etna];
}
