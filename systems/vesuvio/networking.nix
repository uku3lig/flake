{
  networking = {
    dhcpcd.enable = false;
    usePredictableInterfaceNames = true;

    defaultGateway = {
      address = "172.31.1.1";
      interface = "enp1s0";
    };

    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };

    interfaces.enp1s0 = {
      ipv4.addresses = [
        {
          address = "49.13.148.129";
          prefixLength = 32;
        }
      ];

      ipv6.addresses = [
        {
          address = "2a01:4f8:1c1b:9a77::";
          prefixLength = 64;
        }
      ];
    };
  };
}
