{lib, ...}: {
  # mac address
  services.udev.extraRules = ''ATTR{address}=="96:00:03:24:4a:ab", NAME="eth0"'';

  networking = {
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    nameservers = ["1.1.1.1"];

    defaultGateway = "172.31.1.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };

    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "49.13.148.129";
          prefixLength = 32;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a01:4f8:1c1c:8b12::1";
          prefixLength = 64;
        }
      ];
    };
  };
}
