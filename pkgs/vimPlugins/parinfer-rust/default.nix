{ lib, stdenv, source, rustPlatform, llvmPackages, buildVimPluginFrom2Nix }:

let
  parinfer-rust-bin = rustPlatform.buildRustPackage {
    pname = "${source.pname}-bin";
    source = source.version;
    src = source.src;
    #cargoLock = source.cargoLock;

    #cargoSha256 = "H34UqJ6JOwuSABdOup5yKeIwFrGc83TUnw1ggJEx9o4=";
    buildInputs = [
      llvmPackages.libclang
      llvmPackages.clang
      libiconv
    ];

    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    postInstall = ''
      mkdir -p $out/share/kak/autoload/plugins
      cp rc/parinfer.kak $out/share/kak/autoload/plugins/

      rtpPath=$out/share/vim-plugins/parinfer-rust
      mkdir -p $rtpPath/plugin
      sed "s,let s:libdir = .*,let s:libdir = '${placeholder "out"}/lib'," \
      plugin/parinfer.vim >$rtpPath/plugin/parinfer.vim
    '';
  };
in
buildVimPluginFrom2Nix {
  inherit (source) pname version;

  src = parinfer-rust-bin;
  propagatedBuildInputs = [ parinfer-rust-bin ];

  meta = with lib; {
    description = "Infer parentheses for Clojure, Lisp, and Scheme.";
    homepage = "https://github.com/eraserhd/parinfer-rust";
    license = licenses.isc;
    maintainers = with maintainers; [ eraserhd ];
    platforms = platforms.all;
  };
}

