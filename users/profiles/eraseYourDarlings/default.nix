{ config, lib, pkgs, ... }:

let
  inherit (config.home) homeDirectory username;
in
{
  home.persistence."/persist/home/doc" = {
    directories = [
      ".config/pipewire/media-session.d"
      ".gnupg"
      ".cache/starship"
      ".cache/gstreamer-1.0"
      ".cache/lollypop"
      ".config/VSCodium/"
      ".local/share/cargo"
      ".local/share/direnv"
      ".local/share/gnupg"
      ".local/share/icons"
      ".local/share/keyrings"
      ".local/share/lollypop"
      ".local/share/nu"
      ".local/share/nvim"
      ".local/share/rustup"
      ".local/share/themes"
      ".local/share/Trash"
      ".local/share/zoxide"
      ".local/share/zsh"
      ".mozilla/firefox"
      ".ssh"
      ".vscode-oss"
      "Code"
      "Desk"
      "Docs"
      "Downs"
      "Pics"
      "Tunes"
      "Vids"
      "Gits"
    ];

    allowOther = true;
  };

}
