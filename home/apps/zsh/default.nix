{ pkgs, config, lib, ...}:
{
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
        plugins = [ "git" "sudo"]; 
      };
      shellAliases = {
        ll = "ls -l";
	      nhu = "home-manager -f ~/dotfiles/home/home.nix switch";
        cat = "bat";
        ls = "lsd";
        logout = "hyprctl dispatch exit";
        vim = "nvim";
        chwp = "~/.config/hypr/scripts/change_wp.sh";
      };
      history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      };
    };
  };
}
