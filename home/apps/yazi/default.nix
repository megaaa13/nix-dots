{ lib, config, pkgs, ...}:
let
  yazicfg = config.modules.yazi;
	yazi-plugins = pkgs.fetchFromGitHub { 
		owner = "yazi-rs";
		repo = "plugins";
		rev = "4b027c79371af963d4ae3a8b69e42177aa3fa6ee";
		hash = "sha256-auGNSn6tX72go7kYaH16hxRng+iZWw99dKTTUN91Cow=";
  };
in 
{
  options = {
    modules.yazi.enable = lib.mkEnableOption "Enable yazi";
  };
  config = lib.mkIf yazicfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
      settings = {
        manager = {
          ratio = [ 1 3 4 ];
          sort_by = "natural";
          sort_dir_first = true;
          sort_sensitive = false;
          sort_translit = true;
          linemode = "size";
          show_symlink = true;
          title_format = "Yazi {cwd}";
        };
        preview = {
          max_width = 1000;
          max_height = 1000;
        };
        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
        };
      };
      plugins = {
        chmod = "${yazi-plugins}/chmod.yazi";
        full-border = "${yazi-plugins}/full-border.yazi";
        max-preview = "${yazi-plugins}/max-preview.yazi";
        git = "${yazi-plugins}/git.yazi";
        jump-to-char = "${yazi-plugins}/jump-to-char.yazi";
      };
      initLua = ''
        require("full-border"):setup()
        require("git"):setup()
      '';
      keymap = {
        manager.prepend_keymap = [
          {
            on = "T";
            run = "plugin --sync max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = "f";
            run = "plugin jump-to-char";
            desc = "Jump to char";
          }
        ];
      };
    };
  };
}
