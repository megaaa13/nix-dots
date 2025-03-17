{ lib, config, ... }:
let
  sshcfg = config.modules.ssh;
in
{
  options = {
    modules.ssh.enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf sshcfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "oracle" = {
          user = "ubuntu";
          hostname = "158.178.193.249";
          identitiesOnly = true;
        };
        "homelab" = {
          user = "homelab";
          hostname = "192.168.1.4";
          identitiesOnly = true;
      };
    };
  };
}