let
  pkgs = import <nixpkgs> { };
  python = pkgs.python312;
  pythonPackages = python.pkgs;
  lib-path =
    with pkgs;
    lib.makeLibraryPath [
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
      stdenv.cc.cc
    ];

in
with pkgs;
mkShell {
  packages = [
    pythonPackages.pip
    pythonPackages.venvShellHook
    pythonPackages.numpy
    pythonPackages.rasterio
    pythonPackages.gmsh
    pythonPackages.matplotlib
    pythonPackages.pyqt5
    qt5.qtwayland
    cmake
  ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export "LD_LIBRARY_PATH=${lib-path}:$LD_LIBRARY_PATH"

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
