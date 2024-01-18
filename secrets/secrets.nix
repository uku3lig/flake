let
  fuji = "age16ujdfcahmnhe4ygruf28n0urgxycv8zgsp4f8856a5suewhn49cs0mqk7w";
  kilimandjaro = "age1ny0re542mcvf829y28rz6eta9myaqlxasfnn933srw64dlgavpsqc59q79";
  etna = "age1n5was53x7mn3n7pugt3ge8tg5uglq3hzdt7270a04yw3szrqtuuqy0j6tw";

  main = [fuji kilimandjaro];
  all = main ++ [etna];
in {
  "userPassword.age".publicKeys = all;
  "tailscaleKey.age".publicKeys = all;

  "fuji/rootPassword.age".publicKeys = main;
  "kilimandjaro/rootPassword.age".publicKeys = main;
  "etna/rootPassword.age".publicKeys = main ++ [etna];
}
