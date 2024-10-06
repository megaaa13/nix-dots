{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "C development";
  nativeBuildInputs = with pkgs; [
    getopt
    flex
    bison
    gcc
    gnumake
    bc
    pkg-config
    binutils
    cmake
  ];
  buildInputs = with pkgs; [
    elfutils
    ncurses
    openssl
    zlib
  ];
}