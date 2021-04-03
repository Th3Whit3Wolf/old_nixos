# xdg.nix
#
# Set up and enforce XDG compliance. Other modules will take care of their own,
# but this takes care of the general cases.

{ config, home-manager, ... }: {
  ### A tidy $HOME is a tidy mind
  home-manager.users.${config.user.name}.xdg.enable = true;
  home.configFile."wgetrc".text = ''
    # To try ipv6 addresses first:
    prefer-family = IPv6

    # Turn on to prevent following non-HTTPS links when in recursive mode
    httpsonly = on

    # Tune HTTPS security (auto, SSLv2, SSLv3, TLSv1, PFS)
    secureprotocol = TLSv1
  '';
  environment = {
    sessionVariables = {
      # These are the defaults, and xdg.enable does set them, but due to load
      # order, they're not set before environment.variables are set, which could
      # cause race conditions.
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_LIB_HOME = "$HOME/.local/lib";
    };
    variables = {
      # Conform more programs to XDG conventions. The rest are handled by their
      # respective modules.
      __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      ASPELL_CONF = ''
        per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
        personal $XDG_CONFIG_HOME/aspell/en_US.pws;
        repl $XDG_CONFIG_HOME/aspell/en.prepl;
      '';
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      HISTFILE = "$XDG_DATA_HOME/bash/history";
      INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";

      # Tools I don't use
      # SUBVERSION_HOME = "$XDG_CONFIG_HOME/subversion";
      # BZRPATH         = "$XDG_CONFIG_HOME/bazaar";
      # BZR_PLUGIN_PATH = "$XDG_DATA_HOME/bazaar";
      # BZR_HOME        = "$XDG_CACHE_HOME/bazaar";
      # ICEAUTHORITY    = "$XDG_CACHE_HOME/ICEauthority";
    };

    # Move ~/.Xauthority out of $HOME (setting XAUTHORITY early isn't enough)
    extraInit = ''
      export XAUTHORITY=/tmp/Xauthority
      [ -e ~/.Xauthority ] && mv -f ~/.Xauthority "$XAUTHORITY"
    '';
  };
}
