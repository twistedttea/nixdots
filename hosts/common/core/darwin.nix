# Darwin only

{ config, ... }:
{
  home.sessionPath = [ "/opt/homebrew/bin" ];

  home = {
    username = config.hostSpec.username;
    homeDirectory = config.hostSpec.home;
  };
}
