# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "spaceDark") (mkMerge [
    user.packages = with pkgs; [
	my.spacemacs-theme
	my.spacemacs-icons
      ];

    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Space-Dark";
            iconTheme = "Space-Dark";
            cursorTheme = "breeze_cursors";
          };
        };

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        shell.tmux.rcFiles = [ ./config/tmux.conf ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile
            [ ./config/firefox/userChrome.css ];
          qutebrowser.userStyles = concatMapStringsSep "\n" readFile
            (map toCSSFile [
              ./config/qutebrowser/userstyles/monospace-textareas.scss
              ./config/qutebrowser/userstyles/stackoverflow.scss
              ./config/qutebrowser/userstyles/xkcd.scss
            ]);
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      user.packages = with pkgs; [
      ];
      fonts = {
        fonts = with pkgs; [
          fira-code
          fira-code-symbols
	  jetbrains-mono
	  my.san-francisco-font
	  my.san-francisco-mono-font
	  nerdfonts
	  symbola
          siji
          font-awesome-ttf
        ];
        fontconfig.defaultFonts = {
          sansSerif = [ "SFNS Display" ];
          monospace = [ "SF Mono" ];
        };
      };

      # Compositor
      services.picom = {
        fade = true;
        fadeDelta = 1;
        fadeSteps = [ 1.0e-2 1.2e-2 ];
        shadow = true;
        shadowOffsets = [ (-10) (-10) ];
        shadowOpacity = 0.22;
        # activeOpacity = "1.00";
        # inactiveOpacity = "0.92";
        settings = {
          shadow-radius = 12;
          # blur-background = true;
          # blur-background-frame = true;
          # blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 320;
	};
      };
      home-manager.users.${config.user.name}.programs = {
	mako = {
	  backgroundColor = "#292b2e";
	  borderColor = "#5d4d7a";
	  borderRadius = 12;
	  borderSize = 10;
	  font = "SFNS Display Bold 13";
	  margin = "25";
	  textColor = "#b2b2b2";
	  extraConfig = ''
[hidden]
format=(and %h more)
text-color=#686868

[urgency=high]
background-color=#c00000
border-color=#ff0000
	  '';
	};
      };
  ]);
}
