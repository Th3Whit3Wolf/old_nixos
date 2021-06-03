{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      nixos-hardware.url = "github:nixos/nixos-hardware";
      latest.url = "nixpkgs";
      digga.url = "github:divnix/digga/develop";

      ci-agent = {
        url = "github:hercules-ci/hercules-ci-agent";
        inputs = {
          nix-darwin.follows = "darwin";
          nixos-20_09.follows = "nixos";
          nixos-unstable.follows = "latest";
        };
      };

      darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "latest";
      };

      home = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixos";
      };

      impermanence = {
        url = "github:nix-community/impermanence";
        flake = false;
      };

      agenix = {
        url = "github:ryantm/agenix";
        inputs.nixpkgs.follows = "latest";
      };

      naersk = {
        url = "github:nmattia/naersk";
        inputs.nixpkgs.follows = "latest";
      };

      rust = {
        url = "github:oxalica/rust-overlay";
        inputs.nixpkgs.follows = "latest";
      };

      pkgs = {
        url = "path:./pkgs";
        inputs.nixpkgs.follows = "nixos";
      };

      #neovim-nightly = {
      #  url = "github:nix-community/neovim-nightly-overlay";
      #  inputs.nixpkgs.follows = "latest";
      #};

      nixpkgs-wayland = {
        url = "github:colemickens/nixpkgs-wayland";
        inputs.nixpkgs.follows = "nixos";
      };
    };

  outputs =
    { self
    , pkgs
    , digga
    , nixos
    , ci-agent
    , home
    , nixos-hardware
    , nur
    , agenix
    , ...
    }@inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          imports = [ (digga.lib.importers.overlays ./overlays) ];
          overlays = [
            ./pkgs/default.nix
            pkgs.overlay # for `srcs`
            nur.overlay
            agenix.overlay
          ];
        };
        latest = { };
      };

      lib = import ./lib { lib = digga.lib // nixos.lib; };

      sharedOverlays = [
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          modules = ./modules/module-list.nix;
          externalModules = [
            { _module.args.ourLib = self.lib; }
            ci-agent.nixosModules.agent-profile
            home.nixosModules.home-manager
            agenix.nixosModules.age
            ./modules/customBuilds.nix
          ];
        };

        imports = [ (digga.lib.importers.hosts ./hosts) ];
        hosts = {
          # set host specific properties here
          NixOS = { };
          tardis.modules = [ nixos-hardware.nixosModules.common-cpu-amd ];
        };
        importables = rec {
          profiles = digga.lib.importers.rakeLeaves ./profiles // {
            users = digga.lib.importers.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [ cachix core ];
            mobile = [ base laptop ];
          };
        };
      };

      home = {
        modules = ./users/modules/module-list.nix;
        externalModules = [
          "${inputs.impermanence}/home-manager.nix"
        ];
        profiles = [ ./users/profiles ];
        suites = { profiles, ... }:
          with profiles; rec {
            base = [ direnv git ];
          };
      };

      devshell.externalModules = { pkgs, ... }: {
        packages = [ pkgs.agenix ];
      };

      homeConfigurations =
        digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      defaultTemplate = self.templates.flk;
      templates.flk.path = ./.;
      templates.flk.description = "flk template";
    };
}
