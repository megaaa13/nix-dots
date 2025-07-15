{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  hyprlandcfg = config.modules.hyprland;
in
{
  options = {
    modules.hyprland = {
      enable = lib.mkEnableOption "Enable hyprland";
      plugins = lib.mkOption {
        default = [ ];
        description = "List of plugins to enable";
      };
    };
  };
  config = lib.mkIf hyprlandcfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };
      plugins = hyprlandcfg.plugins;
      settings = {
        env = [
          "XCURSOR_SIZE,16"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "MOZ_ENABLE_WAYLAND,1"
          "NVD_BACKEND,direct"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "LIBVA_DRIVER_NAME,nvidia"
          "__GL_GSYNC_ALLOWED,1"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
        ];
        exec-once = [
          "${pkgs.hyprlock}/bin/hyprlock --immediate" # Can be move to a nix module
          "${pkgs.swayosd}/bin/swayosd-server" # Could be started by nix
          "${pkgs.swww}/bin/swww-daemon"
          "${pkgs.swaynotificationcenter}/bin/swaync" # Can be move to a nix module
          "${pkgs.udiskie}/bin/udiskie -s" # Can be move to a nix module
          "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
          "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
          "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
        ];
        monitor = [
          "eDP-1,1920x1080@144,0x0,1"
          "desc:HP Inc. HP M24h 3CM30713P7, 1920x1080@75, 1920x0, 1"
          "desc:Microstep MSI MAG241C 0x30313056, 1920x1080@144, 0x0, 1"
          ",preferred,auto,1"
        ];
        "$mainMod" = "SUPER";
        "$menu" = "rofi -show drun";
        "$waylandtags" = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

        bind = [
          # General
          "$mainMod, Q, exec, kitty"
          "$mainMod, F, exec, firefox"
          "$mainMod, D, exec, vesktop $waylandtags"
          "$mainMod, C, killactive,"
          "$mainMod, W, exec, bash ~/.config/waybar/scripts/hide_waybar.sh"
          "$mainMod, P, exec, sh ~/.config/hypr/scripts/powermenu.sh"
          "$mainMod, E, exec, kitty --single-instance --detach zsh -i -c 'yazi'"
          "$mainMod SHIFT, R, exec, hyprctl reload"
          "$mainMod ALT, V, exec, code $waylandtags"
          "$mainMod, S, exec, spotify $waylandtags"
          "ALT, Space, exec, $menu"
          "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
          "$mainMod, X, exec, hyprpicker | wl-copy"
          "$mainMod, A, exec, killall activate-linux 2>/dev/null || activate-linux -t 'Activate NixOS' -m 'Good luck finding settings' -x 300 -y 100 -f 'JetBrains Mono Nerd Font'"

          # Screenshots
          # Screenshot a monitor
          "$mainMod, PRINT, exec, hyprshot -m output --clipboard-only"
          "$mainMod SHIFT, PRINT, exec, hyprshot -m output -o $HOME/Pictures/Screenshots"

          # Screenshot a region
          ", PRINT, exec, hyprshot -m region --clipboard-only"
          "SHIFT, PRINT, exec, hyprshot -m region -o $HOME/Pictures/Screenshots"

          # Screenshot a window
          "CTRL, PRINT, exec, hyprshot -m window --clipboard-only"
          "CTRL SHIFT, PRINT, exec, hyprshot -m window -o $HOME/Pictures/Screenshots"

          # Resume-pause spotify
          "$mainMod SHIFT, S, exec, playerctl --player=spotify play-pause"

          # Window management
          "$mainMod, Space, fullscreen, 1"
          "$mainMod + CTRL, Space, fullscreen"
          "$mainMod, Tab, togglefloating"
          "ALT, Tab, cyclenext"
          "$mainMod + CTRL, P, pseudo, "
          "$mainMod + CTRL, S, togglesplit,"
          "$mainMod + CTRL, G, togglegroup,"
          "$mainMod + CTRL, C, centerwindow"

          # Focus
          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, KP_End, workspace, 1"
          "$mainMod, KP_Down, workspace, 2"
          "$mainMod, KP_Next, workspace, 3"
          "$mainMod, KP_Left, workspace, 4"
          "$mainMod, KP_Begin, workspace, 5"
          "$mainMod, KP_Right, workspace, 6"
          "$mainMod, KP_Home, workspace, 7"
          "$mainMod, KP_Up, workspace, 8"
          "$mainMod, KP_Prior, workspace, 9"
          "$mainMod, KP_Insert, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, KP_End, movetoworkspace, 1"
          "$mainMod SHIFT, KP_Down, movetoworkspace, 2"
          "$mainMod SHIFT, KP_Next, movetoworkspace, 3"
          "$mainMod SHIFT, KP_Left, movetoworkspace, 4"
          "$mainMod SHIFT, KP_Begin, movetoworkspace, 5"
          "$mainMod SHIFT, KP_Right, movetoworkspace, 6"
          "$mainMod SHIFT, KP_Home, movetoworkspace, 7"
          "$mainMod SHIFT, KP_Up, movetoworkspace, 8"
          "$mainMod SHIFT, KP_Prior, movetoworkspace, 9"
          "$mainMod SHIFT, KP_Insert, movetoworkspace, 10"

          # Move active window to workspace without changing focus with mainMod + CTRL + [0-9]
          "$mainMod CTRL, KP_End, movetoworkspacesilent, 1"
          "$mainMod CTRL, KP_Down, movetoworkspacesilent, 2"
          "$mainMod CTRL, KP_Next, movetoworkspacesilent, 3"
          "$mainMod CTRL, KP_Left, movetoworkspacesilent, 4"
          "$mainMod CTRL, KP_Begin, movetoworkspacesilent, 5"
          "$mainMod CTRL, KP_Right, movetoworkspacesilent, 6"
          "$mainMod CTRL, KP_Home, movetoworkspacesilent, 7"
          "$mainMod CTRL, KP_Up, movetoworkspacesilent, 8"
          "$mainMod CTRL, KP_Prior, movetoworkspacesilent, 9"
          "$mainMod CTRL, KP_Insert, movetoworkspacesilent, 10"

          # Same but laptop ready
          "$mainMod, ampersand, workspace, 1"
          "$mainMod, eacute, workspace, 2"
          "$mainMod, quotedbl, workspace, 3"
          "$mainMod, apostrophe, workspace, 4"
          "$mainMod, parenleft, workspace, 5"
          "$mainMod, code:15, workspace, 6"
          "$mainMod, egrave, workspace, 7"
          "$mainMod, code:17, workspace, 8"
          "$mainMod, ccedilla, workspace, 9"
          "$mainMod, agrave, workspace, 10"

          "$mainMod SHIFT, ampersand, movetoworkspace, 1"
          "$mainMod SHIFT, eacute, movetoworkspace, 2"
          "$mainMod SHIFT, quotedbl, movetoworkspace, 3"
          "$mainMod SHIFT, apostrophe, movetoworkspace, 4"
          "$mainMod SHIFT, parenleft, movetoworkspace, 5"
          "$mainMod SHIFT, code:15, movetoworkspace, 6"
          "$mainMod SHIFT, egrave, movetoworkspace, 7"
          "$mainMod SHIFT, code:17, movetoworkspace, 8"
          "$mainMod SHIFT, ccedilla, movetoworkspace, 9"
          "$mainMod SHIFT, agrave, movetoworkspace, 10"

          "$mainMod CTRL, ampersand, movetoworkspacesilent, 1"
          "$mainMod CTRL, eacute, movetoworkspacesilent, 2"
          "$mainMod CTRL, quotedbl, movetoworkspacesilent, 3"
          "$mainMod CTRL, apostrophe, movetoworkspacesilent, 4"
          "$mainMod CTRL, parenleft, movetoworkspacesilent, 5"
          "$mainMod CTRL, code:15, movetoworkspacesilent, 6"
          "$mainMod CTRL, egrave, movetoworkspacesilent, 7"
          "$mainMod CTRL, code:17, movetoworkspacesilent, 8"
          "$mainMod CTRL, ccedilla, movetoworkspacesilent, 9"
          "$mainMod CTRL, agrave, movetoworkspacesilent, 10"

          "$mainMod SHIFT, right, movetoworkspace, +1"
          "$mainMod SHIFT, left, movetoworkspace, -1"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_down, workspace, e+1"

          # Lock the screen
          "$mainMod, L, exec, hyprlock"

          # Specials workspaces
          "ALT, S, togglespecialworkspace, scratch"
          "ALT SHIFT, S, movetoworkspace, special:scratch"
          "ALT CTRL, S, movetoworkspacesilent, special:scratch"
          "ALT, M, togglespecialworkspace, spotify"

          # "ALT, O, overview:toggle"
        ];

        bindl = [
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioStop, exec, playerctl stop"
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ];

        bindle = [
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower 5"
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise 5"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, movewindow"
        ];

        input = {
          kb_layout = "be";
          kb_options = "compose:rctrl";
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
          sensitivity = 0;
        };
        source = "~/.cache/wal/color-hypr.conf";
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "$color3 $color1 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = true;
          layout = "dwindle";
          allow_tearing = false;
        };
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
        };
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_focuses_monitor = false;
          focus_on_activate = true;
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        master = {
          new_status = "master";
        };
        gestures = {
          workspace_swipe = false;
        };
        windowrule = [
          "float, class:confirm"
          "float, class:dialog"
          "float, class:download"
          "float, class:notification"
          "float, class:error"
          "float, class:splash"
          "float, class:confirmreset"
          "float, title:Open File"
          "float, title:branchdialog"
          "float, class:pavucontrol"
          "idleinhibit fullscreen, fullscreen:1"
          "float,class:(wm-floating)"
          "maximize,class:(wm-maximized)"
          "float,class:(python3)"
          "float, class:(firefox), title:(Incrustation vidéo)"
          "pin, title:(Incrustation vidéo)"
          "workspace special:spotify, class:^(spotify)$"
          "workspace special:spotify, class:^(Spotify)$"
        ];
        layerrule = [
          "noanim, hyprpicker"
          "noanim, selection"
        ];
        device = [
          {
            name = "sino-wealth-usb-keyboard";
            kb_layout = "fr";
          }
          {
            name = "razer-razer-deathadder-essential";
            sensitivity = -0.4;
          }
          {
            name = "corsair-corsair-k70-rgb-mk.2-mechanical-gaming-keyboard";
            kb_layout = "fr";
          }
          {
            name = "ckb1:-corsair-k70-rgb-mk.2-mechanical-gaming-keyboard-vkb";
            kb_layout = "fr";
          }
          {
            name = "steelseries-steelseries-apex-3-tkl";
            kb_layout = "fr";
          }
          {
            name = "razer-razer-mamba-elite";
            sensitivity = -0.3;
          }
        ];
      };
    };
  };
}
