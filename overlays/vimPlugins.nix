final: prev:

{
  vimPlugins = with final.vimUtils;
    prev.vimPlugins // {
      parinfer-rust =
        let
          parinfer-rust-bin = rustPlatform.buildRustPackage {
            inherit (sources.vimP-parinfer-rust) src version cargoLock;

            pname = "${sources.vimP-parinfer-rust.pname}-bin";

            cargoSha256 = "H34UqJ6JOwuSABdOup5yKeIwFrGc83TUnw1ggJEx9o4=";
            nativeBuildInputs = [ llvmPackages.clang ];
            buildInputs = [ llvmPackages.libclang ];
            LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
          };
        in
        buildVimPluginFrom2Nix {
          inherit (sources.vimP-parinfer-rust) src version pname;
          name = "${pname}";
          publisher = "eraserhd";
          sha256 = "1xwahgwjv1ylmy0bwbsisycjlz5r9i1gxz20392a8f8019zhjx90";
        };
    };
}
