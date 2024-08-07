{ pkgs, ... }:

let
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "martin";
in

{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = initial_session;
    };
  };
}
