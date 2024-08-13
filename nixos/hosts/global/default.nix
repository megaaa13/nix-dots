{ pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
    grim
    slurp
    sbctl
    killall
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  programs = {
    git.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
        nb = "echo \"sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname)\" && sudo nixos-rebuild switch --flake ~/dotfiles/nixos#$(hostname)";
        nbo = "echo \"Offline build\" && echo \"sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname)\" && sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname) --option substitute false";
        ncc = "echo \"sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d\" && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d";
        #ns = "SOPS_AGE_KEY_FILE=~/dotfiles/nixos/keys/$USER.txt sops";
        nu = "sudo nix flake update -I ~/dotfiles";
      };
    };
    dconf.enable = true;
  };


  networking.networkmanager.enable = true;
}