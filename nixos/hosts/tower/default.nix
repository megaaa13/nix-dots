{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../global
    ../../modules/secureboot.nix
    ../../modules/start.nix
    ../../modules/bluetooth.nix
  ];

  networking.hostName = "tower";

  # Should not be necessary anymore, because we use home manager
  users.users.martin = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  home-manager.users.martin.imports = [ ../../../home/home.nix ];

  # Default layer configuration
  services.xserver = {
    xkb.layout = "fr";
    xkb.variant = "azerty";
  };

  # Hyprland things

  security.pam.services.hyprlock = { };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Relative to GPU configuration
  services.xserver.videoDrivers = ["nvidia"];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
  ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      # New nvidia driver, in order to FIX THE FCKING XWAYLAND ISSUE (and then the gaming on it !)
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  system.stateVersion = "23.11";
}
