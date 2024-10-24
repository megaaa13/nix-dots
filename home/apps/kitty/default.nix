{ pkgs, config, lib, ...}:
let 
  kittyCfg = config.modules.kitty;
in 
{
  options = {
    modules.kitty.enable = lib.mkEnableOption "Enable kitty";
  };

  config = lib.mkIf kittyCfg.enable {
    programs = {
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        themeFile = "Catppuccin-Mocha";
        font.name = "MesloLGS NF";
        extraConfig = ''
        background_opacity 0.7
        background_blur 1
        include ~/.cache/wal/colors-kitty.conf
        '';
      };
    };
  };
}
