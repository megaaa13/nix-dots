{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../global
    ../../modules/secureboot.nix
    ../../modules/start.nix
    ../../modules/bluetooth.nix
  ];

  networking.hostName = "laptop";

  # Should not be necessary anymore, because we use home manager
  users.users.martin = {
    isNormalUser = true;
    description = "Martin";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  home-manager.users.martin.imports = [ ../../../home/martin.nix ];

  # Default layer configuration
  services.xserver = {
    xkb.layout = "be";
    xkb.variant = "";
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
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      # New nvidia driver, in order to FIX THE FCKING XWAYLAND ISSUE (and then the gaming on it !)
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          energy_performance_preference = "balance_power";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          energy_performance_preference = "performance";
          turbo = "auto";
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
