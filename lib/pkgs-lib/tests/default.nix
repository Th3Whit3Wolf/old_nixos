{ lib, deploy }:
let
  mkChecks = { pkgs, hosts, nodes, homes ? { } }:
    let
      deployHosts = lib.filterAttrs
        (n: _: hosts.${n}.config.nixpkgs.system == pkgs.system)
        nodes;
      deployChecks = deploy.lib.${pkgs.system}.deployChecks { nodes = deployHosts; };
      tests =
        lib.optionalAttrs (deployHosts != { })
          {
            profilesTest = profilesTest {
              inherit pkgs;
              host = hosts.${(builtins.head (builtins.attrNames deployHosts))};
            };
          } // lib.mapAttrs (n: v: v.activationPackage) homes;

    in
    lib.recursiveUpdate tests deployChecks;

  mkTest = { pkgs, host }:
    let
      nixosTesting =
        (import "${toString pkgs.path}/nixos/lib/testing-python.nix" {
          inherit (pkgs) system;
          inherit (host.config.lib) specialArgs;
          inherit pkgs;
          extraConfigurations = [
            host.config.lib.testModule
          ];
        });
    in
    test:
    let
      loadedTest =
        if builtins.typeOf test == "path"
        then import test
        else test;
      calledTest =
        if pkgs.lib.isFunction loadedTest
        then pkgs.callPackage loadedTest { }
        else loadedTest;
    in
    nixosTesting.makeTest calledTest;

  profilesTest = args@{ host, ... }: mkTest args {
    name = "profiles";

    machine = { suites, ... }: {
      imports = suites.allProfiles;
    };

    testScript = ''
      ${host.config.networking.hostName}.systemctl("is-system-running --wait")
    '';
  };
in
{ inherit mkTest profilesTest mkChecks; }
