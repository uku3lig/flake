let
  main = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8 uku3lig"];
in {
  "desktop/rootPassword.age".publicKeys = main;
  "desktop/userPassword.age".publicKeys = main;
}
