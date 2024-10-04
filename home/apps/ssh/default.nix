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
      };
    };
  };
}