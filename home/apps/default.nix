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
    ./vscode
  ];

  modules = {
    zsh.enable = true;
    kitty.enable = true;
    pywal.enable = true;
    spicetify.enable = true;
    git.enable = true;
    yazi.enable = true;
    ssh.enable = true;
    vscode.enable = true;
  };
}
