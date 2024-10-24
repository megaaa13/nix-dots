{ config, pkgs, lib, ... }:
{
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;
}
