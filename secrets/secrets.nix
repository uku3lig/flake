let
  main = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHETiSgdsFFub534ChUKrY3U1ApAlyM7jqFmj3qN65so root@fuji"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbRi03uVAVzqEI5zc8QmP3uthcC1ep55gQL+nQPrEvv root@kilimandjaro"
  ];

  server = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdyRFBTdyCCMQ7I75TyO9voxrrreXQTXtSw+iCRf4XI root@vesuvio"] ++ main;
in {
  "desktop/rootPassword.age".publicKeys = main;
  "desktop/userPassword.age".publicKeys = main;

  "vesuvio/rootPassword.age".publicKeys = server;
  "vesuvio/userPassword.age".publicKeys = server;
}
