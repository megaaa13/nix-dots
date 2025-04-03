{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../global
    ../../modules/secureboot.nix
    ../../modules/start.nix
    ../../modules/bluetooth.nix
    ../../modules/steam.nix
  ];

  networking.hostName = "tower";

  # Should not be necessary anymore, because we use home manager
  users.users.martin = {
    isNormalUser = true;
    description = "Martin";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
  };

  home-manager.users.martin.imports = [ ../../../home/martin.nix ];

  # Default layer configuration
  services.xserver = {
    xkb.layout = "fr";
    xkb.variant = "azerty";
  };

  # Hyprland things

  security.pam.services.hyprlock = { };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Relative to GPU configuration
  services.xserver.videoDrivers = [ "nvidia" ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "balatro"
    ];

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      # New nvidia driver, in order to FIX THE FCKING XWAYLAND ISSUE (and then the gaming on it !)
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    ckb-next.enable = true;
  };

  # RGB
  services.hardware.openrgb.enable = true;
  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    (pkgs.callPackage ../../modules/balatro.nix {
      pkgs = pkgs;
      withMods = true;
      withLinuxPatch = false;
    })
  ];

  system.stateVersion = "23.11";
}
