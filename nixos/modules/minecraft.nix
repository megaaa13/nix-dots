{ pkgs, lib, inputs, ... }:

{

services.minecraft-server = {
  enable = true;
  eula = true;
  openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
  declarative = true;
  whitelist = {
    Megaaa_ = "d9387da5-4e9f-4c84-950e-049dcba89e6b";
    # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
  };
  dataDir = "/var/lib/mcserver";
  serverProperties = {
    server-port = 25565;
    difficulty = 3;
    gamemode = 1;
    max-players = 5;
    motd = "NixOS Minecraft server!";
    white-list = true;
    allow-cheats = true;
  };
  jvmOpts = "";
};
}
