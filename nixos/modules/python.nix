{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    black
    pyright
    (python3.withPackages (
      ps: with ps; [
        numpy
        pandas
        matplotlib
        jupyter
        scapy
        virtualenv
        pygame
      ]
    ))
  ];
}