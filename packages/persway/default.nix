{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "persway";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "johnae";
    repo = "persway";
    rev = "3908055d2334253d357bb90d9872213dc08fbd20";
    sha256 = "sha256-97qJd3o8nJt8IX5tyGWtAmJsIv5Gcw1xoBFwxAqk7I8=";
  };

  # Upstream has Cargo.lock gitignored
  cargoPatches = [ ./update-Cargo-lock.diff ];

  cargoSha256 = "sha256-c/30fqLOw1WvDRNgH+Su0i0kNzWPZ+qZJ6tHGS+UWjM=";
  
  meta = {
    license = lib.licenses.mit;
    maintainers = [
      {
        email = "john@insane.se";
        github = "johnae";
        name = "John Axel Eriksson";
      }
    ];
  };
}
