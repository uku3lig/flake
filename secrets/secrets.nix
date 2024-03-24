let
  fuji = "age16ujdfcahmnhe4ygruf28n0urgxycv8zgsp4f8856a5suewhn49cs0mqk7w";
  kilimandjaro = "age1ny0re542mcvf829y28rz6eta9myaqlxasfnn933srw64dlgavpsqc59q79";
  etna = "age1m3jm6c5ywc5zntv5j4xhals0h28mpea88zzddq88zxcshmhteqwqu89qnh";
  vesuvio = "age1ayxlwx8y0h32w393k6qxx575c9v45jxlkftwtwklhez7eu5jwevs78z7e2";

  main = [fuji kilimandjaro];
  all = main ++ [etna vesuvio];
in {
  "userPassword.age".publicKeys = all;
  "tailscaleKey.age".publicKeys = all;

  "fuji/rootPassword.age".publicKeys = main;
  "fuji-wsl/rootPassword.age".publicKeys = main;
  "kilimandjaro/rootPassword.age".publicKeys = main;
  
  "vesuvio/rootPassword.age".publicKeys = main ++ [vesuvio];

  "etna/rootPassword.age".publicKeys = main ++ [etna];
  "etna/tunnelCreds.age".publicKeys = main ++ [etna];
  "etna/apiRsEnv.age".publicKeys = main ++ [etna];
  "etna/ukubotRsEnv.age".publicKeys = main ++ [etna];
  "etna/ngrokEnv.age".publicKeys = main ++ [etna];
  "etna/minecraftEnv.age".publicKeys = main ++ [etna];
}
