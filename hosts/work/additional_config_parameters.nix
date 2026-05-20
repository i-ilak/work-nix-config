_: rec {
  infra.host = {
    user = "dev";
    homeDir = "/Users/${infra.host.user}";
    hostname = "work";
    sshAuthSock = "${infra.host.homeDir}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
  };
  infra.desktop.fontSize = 13;
  infra.emails.work = "ivan.ilak@mxwbio.com";
}
