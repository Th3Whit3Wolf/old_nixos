{
  description = "A highly structured configuration database.";

  inputs = {
    nixos.url = "nixpkgs/release-21.05";
    latest.url = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
    utils.inputs.flake-utils.follows = "flake-utils";
    digga = {
      url = "github:divnix/digga/develop";
      inputs = {
        nipxkgs.follows = "latest";
        nixlib.follows = "nixos";
        #deploy.follows = "deploy";
        #nixos-generators.follows = "latest";
        #utils.follows = "utils";
        home-manager.follows = "home";
      };
    };

    bud = {
      url = "github:divnix/bud"; # no need to follow nixpkgs: it never materialises
    };

    deploy.follows = "digga/deploy";

    ci-agent = {
      url = "github:hercules-ci/hercules-ci-agent";
      inputs = {
        nix-darwin.follows = "darwin";
        nixos-20_09.follows = "nixos";
        nixos-unstable.follows = "latest";
        flake-compat.follows = "digga/deploy/flake-compat";
      };
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "latest";
    };

    home = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixos";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixos";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixos";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      flake = false;
    };

    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixos";
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "latest";
    };

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs = {
        nixpkgs.follows = "latest";
        flake-compat.follows = "digga/deploy/flake-compat";
        flake-utils.follows = "digga/utils/flake-utils";
      };
    };

    # start ANTI CORRUPTION LAYER
    # remove after https://github.com/NixOS/nix/pull/4641
    nixpkgs.follows = "nixos";
    nixlib.follows = "digga/nixlib";
    blank.follows = "digga/blank";
    utils.follows = "digga/utils";
    flake-utils.follows = "digga/flake-utils";
    # end ANTI CORRUPTION LAYER
  };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , ci-agent
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , rust
    , ...
    }@inputs:
    let
      bud' = bud self; # rebind to access self.budModules
    in
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels = {
          nixos = {
            imports = [ (digga.lib.importers.overlays ./overlays) ];
            overlays = [
              nur.overlay
              agenix.overlay
              rust.overlay
              nvfetcher.overlay
              (import ./pkgs).overlay
              deploy.overlay
            ];
          };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
          })
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "nixos";
            imports = [ (digga.lib.importers.modules ./modules) ];
            externalModules = [
              { lib.our = self.lib; }
              ci-agent.nixosModules.agent-profile
              home.nixosModules.home-manager
              agenix.nixosModules.age
              (bud.nixosModules.bud bud')
              "${inputs.impermanence}/nixos.nix"
            ];
          };

          imports = [ (digga.lib.importers.hosts ./hosts) ];
          hosts = {
            # set host specific properties here
            NixOS = { };
            tardis = { };
          };
          importables = rec {
            profiles = digga.lib.importers.rakeLeaves ./profiles // {
              users = digga.lib.importers.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ cachix core ];
              psd = [ desktop.browser.psd ];
              sway = [ desktop.wm.sway ];

              tardis = [ base laptop psd eraseYourDarlings sway ];
            };
          };
        };

        home = {
          imports = [ (digga.lib.importers.modules ./users/modules) ];
          externalModules = [ "${inputs.impermanence}/home-manager.nix" ];
          importables = rec {
            profiles = digga.lib.importers.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ core direnv git xdg ssh ];
              zsh = [ shell.ZSH ];
              firefox = [ desktop.browser.firefox ];
              psd = [ desktop.browser.psd ];
              sway = [ desktop.wm.sway ];
              waybar = [ desktop.bar.waybar ];
              tardis = [ base dev psd firefox sway waybar eraseYourDarlings zsh ];
            };
          };
        };

        devshell.modules = [ (import ./shell bud') ];

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

      } // {
      budModules = { devos = import ./pkgs/bud; };
    };
}
