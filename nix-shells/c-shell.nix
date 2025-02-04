let
  pkgs = import <nixpkgs> {};
  lib-path = with pkgs; lib.makeLibraryPath [
    libGL
    libGLU
    xorg.libXrender
    xorg.libXcursor
    xorg.libXfixes
    xorg.libXft
    xorg.libXi
    fontconfig
    xorg.libXinerama
    xorg.libxcb
    xorg.libX11
    glib
    zlib
    freetype
    dbus
    stdenv.cc.cc
    nlohmann_json
    glibc
  ];
in with pkgs; mkShell {
    name = "C development";
    nativeBuildInputs = [
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
    buildInputs = [
      elfutils
      ncurses
      openssl
      zlib
      libGL
      libGLU
      xorg.libXrender
      xorg.libXcursor
      xorg.libXfixes
      xorg.libXft
      xorg.xinput
      fontconfig
      xorg.libXinerama
      xorg.libxcb
      xorg.libX11
      xorg.libXi
      glib
      zlib
      freetype
      dbus
      stdenv.cc.cc
      xorg.libXrandr
    ];
    shellHook = ''
      export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
    '';
}
