{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
    cfg = config.nix-polyglot.neovim;

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

    # Create aliases for using neovim with sudo
    aliases = {
        suvim = "sudo -E nvim";
        suvi = "sudo -E nvim";
        suv = "sudo -E nvim"; 
    };

    ## Helpful for creating vim plugin overlay
    # https://nixos.wiki/wiki/Vim
    # https://github.com/NixOS/nixpkgs/blob/98686d3b7f9bf156331b88c2a543da224a63e0e2/pkgs/misc/vim-plugins/overrides.nix
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/generated.nix
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/overrides.nix
    defaultPlugins = with pkgs.vimPlugins; [
    { plugin = vim-easy-align; }
    { plugin = vim-which-key; }
    {
        plugin = vista-vim;
        optional = true;
    }
    {
        plugin = vim-closetag;
        optional = true;
    }
    {
        plugin = nvim-treesitter;
        optional = true;
    }
    {
        plugin = vim-yaml;
        optional = true;
    }];
    
in {
    options.nix-polyglot.neovim =  {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable neovim for nix-polyglot.";
        };
        package = mkOption {
            type = types.package;
            default = pkgs.neovim-unwrapped;
            defaultText = literalExample "pkgs.neovim-unwrapped";
            description = "The package to use for the neovim binary.";
        };
        plugins = mkOption {
            type = with types; listOf (either package pluginWithConfigType);
            default = [ ];
            example = literalExample ''
                with pkgs.vimPlugins; [
                    yankring
                    vim-nix
                    { plugin = vim-startify;
                    config = "let g:startify_change_to_vcs_root = 0";
                    }
                ]
            '';
            description = ''
                List of vim plugins to install optionally associated with
                configuration to be placed in init.vim.
                </para><para>
                This option is mutually exclusive with <varname>configure</varname>.
            '';
        };
    };

    config = mkIf cfg.enable (mkMerge [ 
        {
            home.packages = with pkgs; [
                (cfg.package)
                neovim-remote
                tree-sitter
            ];

            programs.neovim = {
                enable = true;
                package = (cfg.package);
                plugins = defaultPlugins;
                withPython3 = true;
                withNodeJs = true;
            };
        }

        (mkIf config.nix-polyglot.enableZshIntegration {
            programs.zsh.shellAliases = aliases;  
        })
    ]);
}
