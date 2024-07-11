{ pkgs, config, lib, ...}:
{
  programs = {
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      theme = "Catppuccin-Mocha";
      font.name = "MesloLGS NF";
      extraConfig = ''
      background_opacity 0.7
      background_blur 1
      '';
    };
  };
}
