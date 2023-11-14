let
  main = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8 uku3lig"];

  server = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdyRFBTdyCCMQ7I75TyO9voxrrreXQTXtSw+iCRf4XI root@vesuvio"] ++ main;
in {
  "desktop/rootPassword.age".publicKeys = main;
  "desktop/userPassword.age".publicKeys = main;

  "vesuvio/rootPassword.age".publicKeys = server;
  "vesuvio/userPassword.age".publicKeys = server;
}
