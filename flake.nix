# flake.nix --- the heart of my dotfiles
#
# Author:  Henrik Lissner <henrik@lissner.net>
# URL:     https://github.com/hlissner/dotfiles
# License: MIT
#
# Welcome to ground zero. Where the whole flake gets set up and all its modules
# are loaded.

{
  description = "A grossly incandescent nixos config.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/master"; # for packages on the edge
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    impermanence.flake = false;
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland.url = "github:colemickens/nixpkgs-wayland";
    wayland.inputs.master.follows = "master";
    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    persway = {
      url = "github:johnae/persway";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-jq = {
      url = "github:reegnz/jq-zsh-plugin";
      flake = false;
    };

    zsh-histdb = {
      url = "github:larkery/zsh-histdb";
      flake = false;
    };

    zsh-completion-rustup = {
      url = "github:pkulev/zsh-rustup-completion";
      flake = false;
    };

    zsh-completion-cargo = {
      url = "github:MenkeTechnologies/zsh-cargo-completion";
      flake = false;
    };

    zsh-completion-npm = {
      url = "github:lukechilds/zsh-better-npm-completion";
      flake = false;
    };

    zsh-completion-rake = {
      url = "github:unixorn/rake-completion.zshplugin";
      flake = false;
    };

    zsh-rbenv = {
      url = "github:/ELLIOTTCABLE/rbenv.plugin.zsh";
      flake = false;
    };

    zsh-completion-pipenv = {
      url = "github:owenstranathan/pipenv.zsh";
      flake = false;
    };

    zsh-completion-yarn = {
      url = "github:g-plane/zsh-yarn-autocompletions";
      flake = false;
    };

    zsh-completion-git-flow = {
      url = "github:petervanderdoes/git-flow-completion";
      flake = false;
    };

    zsh-tool-forgit = {
      url = "github:wfxr/forgit";
      flake = false;
    };
  };

  outputs = inputs@{ 
    self, 
    nixpkgs, 
    nixpkgs-unstable, 
    naersk, 
    rust,
    persway, 
    wayland, 
    neovim-nightly, 
    ... 
  }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      naersk-lib = naersk.lib."${system}".override;
      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true; # forgive me Stallman senpai
          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };
      pkgs = mkPkgs nixpkgs [
        self.overlay
	rust.overlay
        neovim-nightly.overlay
        persway.overlay
        wayland.overlay
      ];
      pkgs' = mkPkgs nixpkgs-unstable [ ];

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {
      lib = lib.my;

      overlay = final: prev: {
        unstable = pkgs';
        my = self.packages."${system}";
      };

      overlays = mapModules ./overlays import;

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShell."${system}" = import ./shell.nix { inherit pkgs; };

      templates = {
        full = {
          path = ./.;
          description = "A grossly incandescent nixos config";
        };
        minimal = {
          path = ./templates/minimal;
          description = "A grossly incandescent and minimal nixos config";
        };
      };
      defaultTemplate = self.templates.minimal;

      defaultApp."${system}" = {
        type = "app";
        program = ./bin/hey;
      };
    };
}
