{ lib, config, ...}:
let
  gitcfg = config.modules.git;
in
{
  options = {
    modules.git.enable = lib.mkEnableOption "Enable git";
  };
  config = lib.mkIf gitcfg.enable {
    programs.git = {
      enable = true;
      diff-so-fancy.enable = true;
      userName = "megaaa13";
      userEmail = "martin.gyselinck02@gmail.com";
      aliases = {
        graph = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        s = "status";
        d = "diff";
        c = "commit";
        adog = "log --all --decorate --oneline --graph";
      };
      extraConfig = {
        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        pull.rebase = "true";
      };
    };
  };
}
