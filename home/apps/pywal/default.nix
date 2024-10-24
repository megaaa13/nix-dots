{ config, lib, pkgs, ... }:
let 
  pywalcfg = config.modules.pywal;
in
{
  options = {
    modules.pywal.enable = lib.mkEnableOption "Enable pywal";
  };

  config = lib.mkIf pywalcfg.enable {
    home.packages = with pkgs; [
      pywal
    ];
    
    home.file = {
      "${config.xdg.configHome}/wal/templates" = {
        source = ./templates;
        recursive = true;
      };
    };
  };
}