{
  description = "A highly structured configuration database.";

  inputs = {
    nixos_old.url = "nixpkgs/release-20.09";
    nixos.url = "nixpkgs/release-21.05";
    latest.url = "nixpkgs/nixos-unstable";

    digga = {
      url = "github:divnix/digga";
      inputs = {
        nipxkgs.follows = "nixos";
        nixlib.follows = "nixos";
        home-manager.follows = "home";
      };
    };

    bud = {
      url =
        "github:divnix/bud"; # no need to follow nixpkgs: it never materialises
      inputs = {
        nixpkgs.follows = "nixos";
        devshell.follows = "digga/devshell";
      };
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
      inputs.nixpkgs.follows = "latest";
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
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    nix-polyglot = {
      url = "path:./external/nix-polyglot";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
      flake = false;
    };

    # start ANTI CORRUPTION LAYER
    # remove after https://github.com/NixOS/nix/pull/4641
    nixpkgs.follows = "nixos";
    nixlib.follows = "digga/nixlib";
    blank.follows = "digga/blank";
    flake-utils-plus.follows = "digga/flake-utils-plus";
    flake-utils.follows = "digga/flake-utils";
    # end ANTI CORRUPTION LAYER

  };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , nixos_old
    , ci-agent
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , rust
    , naersk
    , nix-polyglot
    , ...
    }@inputs:
    let

      bud' = bud self; # rebind to access self.budModules

      rakePkgs = dir:
        let
          sieve = name: val:
            (name != "default" && name != "bud" && name != "_sources");

          flattenFiltered = digga.lib.flattenTree
            (nixos.lib.filterAttrs sieve (digga.lib.rakeLeaves dir));
          getBasename = name: nixos.lib.last (nixos.lib.splitString "." name);
        in
        nixos.lib.mapAttrs' (n: v: nixos.lib.nameValuePair (getBasename n) v)
          flattenFiltered;

      localPackages = final: prev:
        builtins.mapAttrs
          (name: value:
            let
              sources = (import ./pkgs/_sources/generated.nix) {
                inherit (prev) fetchurl fetchgit;
              };
              package = import (value);
              args = builtins.intersectAttrs (builtins.functionArgs package) {
                source = sources.${name};
              };
            in
            final.callPackage package args)
          (rakePkgs (./pkgs));

    in
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };
        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [
              digga.overlays.patchedNix
              nur.overlay
              agenix.overlay
              rust.overlay
              naersk.overlay
              nvfetcher.overlay
              deploy.overlay
              localPackages
              ./pkgs/default.nix
            ];
          };
          nixos_old = { };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: { our = self.lib; });
          })
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "nixos";
            imports = [ (digga.lib.importModules ./modules) ];
            externalModules = [
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              ci-agent.nixosModules.agent-profile
              home.nixosModules.home-manager
              agenix.nixosModules.age
              bud.nixosModules.bud
              "${inputs.impermanence}/nixos.nix"
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts) ];
          hosts = {
            # set host specific properties here
            NixOS = { };
            tardis = { };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ cachix core ];
              sway = [ desktop.wm.sway ];
              tardis = [ base laptop eraseYourDarlings sway suede ];
            };
          };
        };

        home = {
          imports = [ (digga.lib.importModules ./users/modules) ];
          externalModules = [
            "${inputs.impermanence}/home-manager.nix"
            "${inputs.nix-polyglot}/modules/home-manager/default.nix"

          ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ core direnv git xdg ssh ];
              zsh = [ shell.ZSH ];
              firefox = [ desktop.browser.firefox ];
              eww = [ desktop.widgets.eww ];
              sway = [ desktop.wm.sway ];
              waybar = [ desktop.bar.waybar ];
              tardis = [ base firefox sway waybar eraseYourDarlings zsh dev ];
            };
          };
        };

        devshell.modules = [ (import ./shell bud') ];

        homeConfigurations =
          digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

      } // {
      budModules = { devos = import ./pkgs/bud; };
    };
}
