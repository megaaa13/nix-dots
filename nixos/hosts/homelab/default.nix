# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./minecraft.nix
      ../../modules/python.nix
      ../../modules/docker.nix
    ];
  boot.supportedFilesystems = [ "ntfs" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "homelab";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n = {
    supportedLocales = [
      "fr_FR.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.homelab = {
    isNormalUser = true;
    description = "HomeLab";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFbvwggs8Cqc7uvAn4R5ORDxW5mfAQVPoiGyyEsQUea martin@nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQzv/+zBKiuOydoOLf64HtoiUJTXjdY42Gxv3LtXBq2W8XWXyp07ydT57UXgY5wZ42WM3n+jme5gIJAwgcyG/BK8jYDoPQdkEAQUNkl6nQpJflBO7gFG/KYKe3aWSoyY0KUjdpc5Pv5hibhYGfeNwYxJU1Te+gVnA9C9ZWfAU0cnU334esJtJHMcQLxx7zoV3IhS+ha15rs+W5HGITOcjP/+yIm1TRLmWcyvOfUdzr1UVt+OTsG+LBhtNFu2dF//v31xgtVvYFU+zxSb/mhhT2TJkQPPIKnyF+FOv47Kuab/+ysPmxTkmZ0/flera1WztIN8mKn0FrDLksAaw7xvopg+yaDF3o8oRY1OAdLy5x6Gr1XlnisZH2OMRc3UQKEUidFK5NCp2pWz4e0Yp47f/2vyde4OyewQpptSJE0/RxFeeASp2gydJ32VPZMXLAs3n0uxvrLUo9I26wrtP7eRsGOpgmA1iq4HkGgZpjGkqf4CVb41QrYFqwqlu7zbXhi50= marti@pc-martin"
    ];
  };

  home-manager.users.homelab.imports = [ ../../../home/homelab.nix ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    zsh
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  programs = {
    nix-ld.enable = true; # VSCode server
    zsh.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.X11Forwarding = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
