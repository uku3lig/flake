let
  fuji = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHETiSgdsFFub534ChUKrY3U1ApAlyM7jqFmj3qN65so root@fuji";
  kilimandjaro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbRi03uVAVzqEI5zc8QmP3uthcC1ep55gQL+nQPrEvv root@kilimandjaro";

  main = [fuji kilimandjaro];
  server = main;
in {
  "userPassword.age".publicKeys = server;
  "tailscaleKey.age".publicKeys = server;

  "fuji/rootPassword.age".publicKeys = main;
  "kilimandjaro/rootPassword.age".publicKeys = main;
}
