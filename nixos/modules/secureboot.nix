{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # Lanzaboote require some manual steps
  # `sbctl create-keys`
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
