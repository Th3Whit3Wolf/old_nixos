{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.lang.ruby;
  jsonFormat = pkgs.formats.json { };
  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional = mkEnableOption "optional" // {
        description = "Don't load by default (load with :packadd)";
      };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };
in {
  options.modules.dev.lang.ruby = {
    enable = mkBoolOpt false;
    neovimPlugins  = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [
         { plugin = pkgs.vimPlugins.vim-ruby;  optional = true;}
	 # sheerun/vim-yardoc
      ]; 
    };
    vscode = {
      ext = mkOption {
        type = types.listOf types.package;
        description = "List of vscode extensions to enable";
        default = (with pkgs.vscode-extensions; [
          rebornix.Ruby
          #hridoy.rails-snippets
          vortizhe.simple-ruby-erb
        ]);
      };
      settings = mkOption {
        type = jsonFormat.type;
        description = ''
          Configuration written to Visual Studio Code's
          <filename>settings.json</filename>.
        '';
        default = {
          "ruby" = {
            "format" = "rubocop";
            "lint" = {
              "reek" = { "useBundler" = true; };
              "rubocop" = { "useBundler" = true; };
            };
            "useBundler" = true;
            "useLanguageServer" = true;
          };
        };
      };
    };
    zsh_plugin_text = mkOption {
      type = types.lines;
      description = "How to source necessary zsh plugins";
      default = ''
        # Rake Completions
        path+="${inputs.zsh-completion-rake}"
        fpath+="${inputs.zsh-completion-rake}"
        #source ${inputs.zsh-completion-rake}/rake.plugin.zsh

        # Autoload rbenv
        path+="${inputs.zsh-rbenv}"
        fpath+="${inputs.zsh-rbenv}"
        #source ${inputs.zsh-rbenv}/rbenv.plugin.zsh

              '';
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ruby
      rubyPackages.rake
      rubyPackages.rails
      rubocop
      solargraph
      rbenv
      bundler
    ];

    env.BUNDLE_USER_CACHE = "$XDG_CACHE_HOME/bundle";
    env.BUNDLE_USER_CONFIG = "$XDG_CONFIG_HOME/bundle";
    env.BUNDLE_USER_PLUGIN = "$XDG_DATA_HOME/bundle";
    env.GEM_HOME = "$XDG_DATA_HOME/gem";
    env.GEM_SPEC_CACHE = "$XDG_CACHE_HOME/gem";
    env.PATH = [ "$GEM_HOME/bin" ];

    environment.shellAliases = {
      sgem = "sudo gem";
      rfind = "fd . -e rb -0 | xargs rg";
      rb = "ruby";
      gin = "gem install";
      gun = "gem uninstall";
      gli = "gem list";
      jimweirich = "rake";
      rake = "rake";
      brake = "bundle exec rake";
      srake = "sudo rake";
      sbrake = "sudo bundle exec rake";
      devlog = "tail -f log/development.log";
      prodlog = "tail -f log/production.log";
      testlog = "tail -f log/test.log";
      rc = "rails console";
      rcs = "rails console --sandbox";
      rd = "rails destroy";
      rdb = "rails dbconsole";
      rgen = "rails generate";
      rgm = "rails generate migration";
      rp = "rails plugin";
      ru = "rails runner";
      rs = "rails server";
      rsd = "rails server --debugger";
      rsp = "rails server --port";
      rdm = "rake db:migrate";
      rdms = "rake db:migrate:status";
      rdr = "rake db:rollback";
      rdc = "rake db:create";
      rds = "rake db:seed";
      rdd = "rake db:drop";
      rdrs = "rake db:reset";
      rdtc = "rake db:test:clone";
      rdtp = "rake db:test:prepare";
      rdmtc = "rake db:migrate db:test:clone";
      rdsl = "rake db:schema:load";
      rlc = "rake log:clear";
      rn = "rake notes";
      rr = "rake routes";
      rrg = "rake routes | rg";
      rt = "rake test";
      rmd = "rake middleware";
      rsts = "rake stats";
      sstat = "thin --stats '/thin/stats' start";
      sg = "ruby script/generate";
      sd = "ruby script/server --debugger";
      sp = "ruby script/plugin";
      sr = "ruby script/runner";
      ssp = "ruby script/spec";
      sc = "ruby script/console";
    };
  };
}
