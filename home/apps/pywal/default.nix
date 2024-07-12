{ config, ... }:
{
    home.file = {
        "${config.xdg.configHome}/wal/templates" = {
            source = ./templates;
            recursive = true;
        };
    };
}