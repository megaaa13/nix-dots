{
  pkgs,
  config,
  lib,
  ...
}:
let
  zshcfg = config.modules.zsh;
in
{
  options = {
    modules.zsh.enable = lib.mkEnableOption "Enable zsh";
  };
  config = lib.mkIf zshcfg.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "powerlevel10k-config";
            src = lib.cleanSource ./.;
            file = ".p10k.zsh";
          }
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = pkgs.zsh-nix-shell;
          }
        ];
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "sudo"
          ];
        };
        shellAliases = {
          ll = "ls -l";
          nhu = "home-manager -f ~/dotfiles/home/home.nix switch";
          cat = "bat";
          ls = "lsd";
          logout = "hyprctl dispatch exit";
          vim = "nvim";
          chwp = "~/.config/hypr/scripts/change_wp.sh";
          nb = "echo \"sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname)\" && sudo nixos-rebuild switch --flake ~/dotfiles/nixos#$(hostname)";
          nbo = "echo \"Offline build\" && echo \"sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname)\" && sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname) --option substitute false";
          ncc = "echo \"sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d\" && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d";
          #ns = "SOPS_AGE_KEY_FILE=~/dotfiles/nixos/keys/$USER.txt sops";
          nu = "sudo nix flake update --flake ~/dotfiles/";
          nsh = "FILENAME=$(ls -1 ~/dotfiles/nix-shells | rofi -dmenu) && nix-shell ~/dotfiles/nix-shells/$FILENAME";
          sr = "~/.config/hypr/scripts/remote_send.sh";
        };
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
        };
      };
    };
  };
}
