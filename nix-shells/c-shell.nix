let
  pkgs = import <nixpkgs> {};
  lib-path = pkgs.lib.makeLibraryPath [
    pkgs.glibc
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
    ];
    shellHook = ''
      export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
    '';
}
