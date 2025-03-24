{
  pkgs,
  lib,
  config,
  ...
}:
let
  latexcfg = config.modules.latex;
in
{
  options = {
    modules.latex.enable = lib.mkEnableOption "Enable latex";
  };

  config = lib.mkIf latexcfg.enable {
    programs = {
      texlive = {
        enable = true;
        extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
      };
      tex-fmt = {
        enable = true;
        settings = {
          wrap = true;
          wraplen = 80;
          tabsize = 2;
          tabchar = "space";
          verbosity = "warn";
        };
      };
    };
  };
}
