{ config, pkgs, inputs, ... }:

{
  imports = [
    ./apps
    ./hyprland
  ];

  modules = {
    zsh.enable = true;
    kitty.enable = true;
    pywal.enable = true;
    spicetify.enable = true;
    git.enable = true;
    yazi.enable = true;
    ssh.enable = true;
    vscode.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  home.username = "martin";
  home.homeDirectory = "/home/martin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    neofetch
    bat
    lsd
    qview
    playerctl
    cliphist
    wl-clipboard
    grim
    slurp
    swww
    swayosd
    wofi
    hyprshot
    hyprpicker
    pavucontrol
    networkmanagerapplet
    swaynotificationcenter
    prismlauncher
    #cava
    obs-studio
    vlc
    signal-desktop
    vesktop
    inputs.themecord.packages.x86_64-linux.default
    udiskie
    firefox
    thunderbird
    teams-for-linux
    md2pdf
    qgis
    zotero
    onedriver
    nixfmt-rfc-style
    direnv
    clang-tools
    activate-linux
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/martin/etc/profile.d/hm-session-vars.sh
  #
  home = {
    sessionVariables = {
      GTK_THEME = "Orchis-Dark";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "yazi-open.desktop";
        "application/pdf" = "firefox.desktop";
	"text/plain" = "code.desktop";
      };
    };
    portal = {
      enable = true;
    };
    desktopEntries = {
      yazi-open = {
        name = "Open with Yazi";
        exec = "kitty yazi";
        terminal = false;
        mimeType = [ "inode/directory" ];
        noDisplay = true;
	    };
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
