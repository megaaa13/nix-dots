{ osConfig, config, ... }:
let
  defaultBar = {
    layer = "top";
    position = "top";
    height = 30;
    spacing = 0;
    reload_style_on_change = true;
    cpu = {
      format = " {usage}%";
      interval = 3;
    };
    "custom/gpu" = {
      interval = 3;
      exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
      format = "󰢮 {}%";
      tooltip = false;
    };
    memory = {
      format = "󰾅 {used:0.1f} GB";
      format-alt = "󰾅 {used:0.1f}/{total:0.1f} GB";
      tooltip = false;
      interval = 3;
    };
    temperature = {
      format = " {temperatureC}°C";
      format-icons = ["" "" "" "" ""];
      tooltip = false;
    };
    disk = {
      format = " {specific_used:0.2f}/{specific_total:0.2f}GB";
      format-alt = " {percentage_used}% ({specific_used:0.2f})";
      tooltip = false;
      unit = "GB";
      interval = 30;
    };
    network = {
      format = "󰹹 {bandwidthTotalBytes}";
      format-disconnected = "No Internet 󰖪";
      format-linked = "{ifname} (No IP) ‼️";
      format-alt = " {bandwidthUpBytes} |  {bandwidthDownBytes}";
      format-wifi = "{essid} ({signalStrength}%) 󰖩";
      format-ethernet = "{ipaddr}/{cidr}  ";
      tooltip = false;
      interval = 1;
    };
    battery = {
      states = {
        warning = 20;
        critical = 10;
      };
      format = "{capacity}% {icon}";
      format-alt = "{time} {icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
    };
    backlight = {
      format = "{icon} {percent}%";
      interval = 2;
      format-icons = ["󰹇" "󰃜" "󰃛" "󰃝" "󰃟" "󰃠"];
      states = {
        normal = 0;
        warning = 80;
        critical = 90;
      };
      on-click = "hyprshade toggle blue-light-filter";
      on-scroll-down = "swayosd-client --brightness lower 5";
      on-scroll-up = "swayosd-client --brightness raise 5";
      tooltip = false;
    };
    tray = {
      icon-size = 16;
      spacing = 10;
    };
    pulseaudio = {
      format = "{icon} {volume}";
      format-bluetooth = "{icon}  {volume}";
      format-bluetooth-muted = "󰝟 {icon} ";
      format-muted = "";
      tooltip-format = "{icon} {desc} // {volume}%";
      scroll-step = 5;
      format-icons = {
        headphones = "";
        handsfree = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
        ];
      };
      on-click = "pavucontrol";
    };
    clock = {
      format = "{:%H:%M 󰃭 %d %b %Y}";
      # format-alt = "{:%d-%m-%Y}";
      tooltip = false;
    };
    "custom/notifications" = {
      "tooltip" = false;
      "format" = "{icon}";
      "format-icons" = {
        notification = "<span foreground='red'><sup></sup></span>";
        none = "";
        dnd-notification = "<span foreground='red'><sup></sup></span>";
        dnd-none = "";
        inhibited-notification = "<span foreground='red'><sup></sup></span>";
        inhibited-none = "";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
    "custom/chwp" = {
      format = "";
      tooltip-format = "Change wallpaper";
      on-click = "~/.config/hypr/scripts/change_wp.sh";
    };
    "custom/spotify" = {
      format = "{}";
      escape = true;
      return-type = "text";
      max-length = 40;
      interval = 5;
      on-click = "playerctl -p spotify play-pause";
      on-click-right = "playerctl -p spotify play-pause";
      smooth-scrolling-threshold = 10;
      on-scroll-up = "playerctl -p spotify next";
      on-scroll-down = "playerctl -p spotify previous";
      exec = "~/.config/waybar/scripts/spotify.sh";
      exec-if = "pgrep spotify";
      tooltip = false;
    };
    "custom/weather" = {
      format = "{}";
      tooltip = true;
      interval = 600;
      exec = "python ~/.config/waybar/scripts/weather.py";
      return-type = "json";
    };
    "hyprland/workspaces" = {
      disable-scroll = true;
      format = "{name} {icon} ";
      "format-icons" = {  #Could be good to develop that with hyprsome
        # "1" = "";
        # "2" = "";
        # "3" = "";
        # "4" = "";
        # "5" = "";
        "urgent" = "󰗖";
        "active" = "󰝥";
        "default" = "󰝦";
      };
      #persistent-workspaces = {
      #  "*" = 5;
      #};
      sort-by-number = true;
    };
    "hyprland/window" = {
      format = "{}";
      separate-outputs = true;
      max-length = 32;
      "rewrite" = {
        "(.*)kitty" = "> [$1]";
        "(.*)Mozilla Firefox" = "Firefox 󰈹";
        "(.*)BlueMail" = "BlueMail 󰊫 ";
        "(.*)Visual Studio Code" = "Code 󰨞";
        "(.*)Dolphin" = "$1 󰉋";
        "(.*)Spotify Premium" = "Spotify 󰓇";
        "(.*)Steam" = "Steam 󰓓";
      };
    };
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    settings = {
      uniqueBar = defaultBar // {
        modules-left = if (osConfig.networking.hostName == "tower") then
          [
            "hyprland/workspaces"
            "cpu"
            "custom/gpu"
            "memory"
            "disk"
            # "network"
          ]
        else
        [
          "hyprland/workspaces"
          "cpu"
          "custom/gpu"
          "memory"
          "temperature"
          "disk"
          # "network"
        ];
        modules-center = [ "hyprland/window" ];
        
        modules-right = if (osConfig.networking.hostName == "tower") then
          [
            "pulseaudio"
            "tray"
            "custom/spotify"
            "custom/chwp"
            "custom/notifications"
            "custom/weather"
            "clock"
          ]
        else
          [
            "pulseaudio"
            "backlight"
            "battery"
            "tray"
            "custom/spotify"
            "custom/chwp"
            "custom/notifications"
            "custom/weather"
            "clock"
          ];
      };
    };
  };

  home.file = {
    "${config.xdg.configHome}/waybar/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
