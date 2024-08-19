{ pkgs, lib, ... }:
{
  # Lanzaboote require some manual steps
  # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  # `sbctl create-keys`
  # Run lanzaboote by rebuilding the system
  # `sbctl verify` # Everything except the kernel should be signed
  # Enable secure boot in the BIOS
  # `sbctl enroll`
  # reboot
  # `bootctl status`
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
