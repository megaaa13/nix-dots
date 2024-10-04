{ ... }:
{
  imports = [
    ./zsh
    ./kitty
    ./pywal
    ./spicetify
    ./git
    ./yazi
    ./ssh
  ];

  modules = {
    ssh.enable = true;
  };
}
