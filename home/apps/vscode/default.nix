{
  config,
  lib,
  pkgs,
  ...
}:
let
  vscodecfg = config.modules.vscode;
in
{
  options = {
    modules.vscode.enable = lib.mkEnableOption "Enable vscode";
  };

  config = lib.mkIf vscodecfg.enable {
    programs = {
      vscode = {
        enable = true;
        profiles.default.extensions = with pkgs.vscode-extensions; [
          llvm-vs-code-extensions.vscode-clangd
          mkhl.direnv
          jnoortheen.nix-ide
          github.copilot
          github.copilot-chat
          ms-python.vscode-pylance
          ms-python.python
          tomoki1207.pdf
          james-yu.latex-workshop
        ];
      };
      direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };
    };
  };
}
