{ config, lib, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../modules/secureboot.nix
        ../../modules/start.nix
        ../../configuration.nix # Dead brain time
    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.martin = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "input" ];
    };

    networking.hostName = "tower";

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };
    services.udisks2.enable = true;

    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    security.pam.services.hyprlock = { };

    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    services.xserver.videoDrivers = ["nvidia"];

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