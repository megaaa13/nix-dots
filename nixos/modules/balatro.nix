{
  pkgs,
  withMods ? true,
  withLinuxPatch ? true, ...
}:
let
  version = "1.0.1o";
  balatroExe = pkgs.requireFile {
    name = "balatro";
    url = "https://store.steampowered.com/app/2379780/Balatro/";
    # Use `nix hash file --sri --type sha256` to get the correct hash
    hash = "sha256-JjC9mxzTy/mewXY5cosDg4tclUMQrn2O5F1SZytDk7w=";
  };
  balatroIcon = pkgs.fetchurl {
    name = "balatro.png";
    url = "https://static.wikia.nocookie.net/balatrogame/images/e/ef/Joker.png";
    sha256 = "sha256-o7ZifsLogOI6zMfsa5FIBGK4hdqES5QHIJAIOQVgWK8=";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "balatro";
  inherit version;
  nativeBuildInputs = [
    pkgs.p7zip
    pkgs.copyDesktopItems
    pkgs.makeWrapper
  ];
  buildInputs = [ pkgs.love ] ++ pkgs.lib.optional withMods pkgs.lovely-injector;
  dontUnpack = true;
  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "balatro";
      desktopName = "Balatro";
      exec = "balatro";
      keywords = [ "Game" ];
      categories = [ "Game" ];
      icon = balatroIcon;
    })
  ];
  buildPhase = ''
    runHook preBuild
    tmpdir=$(mktemp -d)
    7z x ${balatroExe} -o$tmpdir -y
    ${if withLinuxPatch then "patch $tmpdir/globals.lua -i ${./globals.patch}" else ""}
    patchedExe=$(mktemp -u).zip
    7z a $patchedExe $tmpdir/*
    runHook postBuild
  '';

  # The `cat` bit is a hack suggested by whitelje (https://github.com/ethangreen-dev/pkgs.lovely-injector/pull/66#issuecomment-2319615509)
  # to make it so that pkgs.lovely will pick up Balatro as the game name. The `LD_PRELOAD` bit is used to load pkgs.lovely and it is the
  # 'official' way of doing it.
  installPhase = ''
    runHook preInstall
    install -Dm444 ${balatroIcon} -t $out/share/icons/

    cat ${pkgs.lib.getExe pkgs.love} $patchedExe > $out/share/Balatro
    chmod +x $out/share/Balatro

    makeWrapper $out/share/Balatro $out/bin/balatro ${pkgs.lib.optionalString withMods "--prefix LD_PRELOAD : '${pkgs.lovely-injector}/lib/liblovely.so'"}
    runHook postInstall
  '';

  meta = {
    description = "Poker roguelike";
    longDescription = ''
      Balatro is a hypnotically satisfying deckbuilder where you play illegal poker hands,
      discover game-changing jokers, and trigger adrenaline-pumping, outrageous combos.
    '';
    license = pkgs.lib.licenses.unfree;
    homepage = "https://store.steampowered.com/app/2379780/Balatro/";
    maintainers = [ pkgs.lib.maintainers.antipatico ];
    platforms = pkgs.love.meta.platforms;
    mainProgram = "balatro";
  };
}