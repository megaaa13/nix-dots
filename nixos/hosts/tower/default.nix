{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../global
    ../../modules/secureboot.nix
    ../../modules/start.nix
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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      # New nvidia driver, in order to FIX THE FCKING XWAYLAND ISSUE (and then the gaming on it !)
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "555.58";
          sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";              
          sha256_aarch64 = lib.fakeSha256;
          openSha256 = lib.fakeSha256;
          settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
          persistencedSha256 = lib.fakeSha256;
        };
    };
  };

  system.stateVersion = "23.11";
}