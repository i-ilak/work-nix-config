_: {
  infra.host = {
    user = "iilak";
    hostname = "mxw-dalco01";
    homeDir = "/home/iilak";
  };
  infra.desktop = {
    fontSize = 13;
    i3.modifier = "Mod4";
    polybar = {
      monitor = "VNC-0";
      network.interface = "eno1";
    };
  };
}
