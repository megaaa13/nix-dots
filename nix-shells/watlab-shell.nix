let
  pkgs = import <nixpkgs> {};
  python = pkgs.python312;
  pythonPackages = python.pkgs;
  lib-path = with pkgs; lib.makeLibraryPath [
    libGL
    libGLU
    xorg.libXrender
    xorg.libXcursor
    xorg.libXfixes
    xorg.libXft
    fontconfig
    xorg.libXinerama
    xorg.libxcb
    xorg.libX11
    glib
    zlib
    freetype
    dbus
    nlohmann_json
    binutils
    stdenv.cc.cc
    glibc
    libgcc
  ];

in with pkgs; mkShell {
  packages = [
    pythonPackages.pip
    pythonPackages.venvShellHook
    pythonPackages.numpy
    pythonPackages.rasterio
    pythonPackages.gmsh     
    pythonPackages.matplotlib
    pythonPackages.pyqt5
    qt5.qtwayland
    getopt
    flex
    bison
    gnumake
    gcc
    bc
    pkg-config
    cmake
    stdenv.cc.cc
    libgcc
  ];

  buildInputs = [
    glibc.static
  ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export "LD_LIBRARY_PATH=${lib-path}:${glibc.out}/lib:${gcc.out}/lib:$LD_LIBRARY_PATH"

    VENV=.venv
    if test ! -d $VENV; then
      python -m venv $VENV
      source ./$VENV/bin/activate
      pip install watlab
    fi

    source ./$VENV/bin/activate
    export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
  '';
}
