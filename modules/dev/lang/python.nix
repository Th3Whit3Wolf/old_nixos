# modules/dev/python.nix --- https://godotengine.org/
#
# Python's ecosystem repulses me. The list of environment "managers" exhausts
# me. The Py2->3 transition make trainwrecks jealous. But SciPy, NumPy, iPython
# and Jupyter can have my babies. Every single one.

{ inputs, config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.lang.python;
  jsonFormat = pkgs.formats.json { };
in {
  options.modules.dev.lang.python = {
    enable = mkBoolOpt false;
    vscode = {
      ext = mkOption {
        type = types.listOf types.package;
        description = "List of vscode extensions to enable";
        default = (with pkgs.vscode-extensions; [
          ms-python.python
          ms-toolsai.jupyter
          batisteo.vscode-django
          CodeYard.flask-snippets
          frhtylcn.pythonsnippets
          LittleFoxTeam.vscode-python-test-adapter
          njpwerner.autodocstring
          dongli.python-preview
          ms-toolsai.jupyter
        ]);
      };
      settings = mkOption {
        type = jsonFormat.type;
        description = ''
          Configuration written to Visual Studio Code's
          <filename>settings.json</filename>.
        '';
        default = { "python.autoComplete.addBrackets" = true; };
      };
    };
    zsh_plugin_text = mkOption {
      type = types.lines;
      description = "How to source necessary zsh plugins";
      default = ''
        # PIP Completions
        path+="${inputs.zsh-completion-pipenv}"
        fpath+="${inputs.zsh-completion-pipenv}"
        #source ${inputs.zsh-completion-pipenv}/pipenv.plugin.zsh
                '';
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      python38
      python38Packages.pip
      python38Packages.ipython
      python38Packages.black
      python38Packages.setuptools
      python38Packages.pylint
      python38Packages.poetry
      python38Packages.jedi
      python38Packages.pynvim
      python38Packages.python-language-server
      python38Packages.pyls-isort
      python38Packages.isort
    ];

    env.IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
    env.PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
    env.PYLINTHOME = "$XDG_DATA_HOME/pylint";
    env.PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
    env.PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
    env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    env.WORKON_HOME = "$XDG_DATA_HOME/virtualenvs";

    environment.shellAliases = {
      py = "python";
      py2 = "python2";
      py3 = "python3";
      po = "poetry";
      ipy = "ipython --no-banner";
      ipylab = "ipython --pylab=qt5 --no-banner";
    };
  };
}
