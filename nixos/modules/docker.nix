{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [ 23456 24454 ]; 
  virtualisation.docker = {
    enable = true;
  };
  users.users.homelab.extraGroups = [ "docker" ];
}
