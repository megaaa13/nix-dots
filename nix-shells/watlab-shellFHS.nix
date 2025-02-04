{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSEnv {
  name = "Watlab";
  targetPkgs = pkgs: (with pkgs; [
    python3
    python3Packages.pip
    python3Packages.virtualenv
    libGL
    libGLU
    xorg.libXrender
    xorg.libXcursor
    xorg.libXfixes
    xorg.libXft
    fontconfig
    xorg.libXinerama
    xorg.libX11
    glib
    glibc.static
    zlib
    freetype
    dbus
    expat
    cmake
    gcc
  ]);
  runScript = "zsh";
}).env
