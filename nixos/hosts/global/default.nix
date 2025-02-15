{ pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../modules/python.nix
  ];
  
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];
  # boot.tmp.cleanOnBoot = lib.mkDefault true;

  time.timeZone = "Europe/Brussels";

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

  console.keyMap = "fr";

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    wget
    vim
    neovim
    libnotify
    zsh
    git
    pipewire
    zip
    unzip
    wireplumber
    sbctl
    ncdu
    killall
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.hurmit
    nerd-fonts.caskaydia-cove
    nerd-fonts.droid-sans-mono
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.udisks2.enable = true;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };


  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  # Spotify discovery
  networking.firewall.allowedUDPPorts = [ 5353 ];

  networking.networkmanager.enable = true;
}
