{ pkgs, lib, inputs, config, ... }:
let 
  spicecfg = config.modules.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options = {
    modules.spicetify.enable = lib.mkEnableOption "Enable spicetify";
  };

  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  config = lib.mkIf spicecfg.enable {

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "spotify"
    ];


    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.default;
      colorScheme = "Ocean";
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        bookmark
        keyboardShortcut
        shuffle
        powerBar
        fullAlbumDate
        #phraseToPlaylist
        songStats
        # copyToClipboard
        hidePodcasts
        autoSkip
        playNext
        volumePercentage
	      queueTime
        # adblock # Can be useful
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];
    };
  };  
}
