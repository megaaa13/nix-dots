{ pkgs, lib, inputs, ... }:
let 
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.comfy;
    colorScheme = "nord";

    enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        bookmark
        keyboardShortcut
        shuffle
        powerBar
        fullAlbumDate
        phraseToPlaylist
        songStats
        copyToClipboard
        hidePodcasts
        autoSkip
        playNext
        volumePercentage
        # adblock # Can be useful
      ];

    enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];

  };
}
