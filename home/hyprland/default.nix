{ pkgs, config, osConfig, ... }:

{
    programs = {
        waybar.enable = true;
        hyprlock.enable = true;
        rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            terminal = "kitty";
            theme = "~/.config/rofi/themes/theme.rasi";
        };
    };

    home.file = {
        "${config.xdg.configHome}/waybar" = {
            source = ./waybar;
            recursive = true;
        };
        "${config.xdg.configHome}/hypr/hyprlock.conf" = {
            source = ./hyprlock/hyprlock.conf;
        };
        "${config.xdg.configHome}/hypr/scripts" = {
            source = ./scripts;
            recursive = true;
        };
        "${config.xdg.configHome}/swaync" = {
            source = ./swaync;
            recursive = true;
        };
        "${config.xdg.configHome}/rofi" = {
            source = ./rofi;
            recursive = true;
        };
        "${config.xdg.configHome}/hypr/autostart" = {
            source = ./hypr/autostart;
        };
        "${config.xdg.configHome}/hypr/hyprland.conf" = {
            source = ./hypr/hyprland.conf;
        };
        "${config.xdg.configHome}/hypr/src" = {
            source = ./hypr/src;
            recursive = true;
        };
    };
}

