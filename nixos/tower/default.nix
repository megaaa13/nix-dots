{ config, lib, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./secureboot.nix
        ../configuration.nix
    ];

    networking.hostName = "tower";

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

}