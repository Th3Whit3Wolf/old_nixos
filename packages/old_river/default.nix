
{ fetchFromGitHub, callPackage, stdenv, pkgconfig, zig, wayland, wayland-protocols, wlroots
, libxkbcommon, libudev, libevdev, xorg, pixman, libGL }:

stdenv.mkDerivation rec {
  name = "river";
  #wlroots = import ./wlroots.nix;
  wlroots_12 = (callPackage ./wlroots.nix {});
  src = fetchFromGitHub {
    owner = "ifreund";
    repo = "river";
    fetchSubmodules = true;
    rev = "3c1f1df0c0faa561f5f993e05ba0c8ad3e56954f";
    # date = 2020-11-18T15:28:33+01:00;
    sha256 = "PY2VbZILXpDQDGFf9hNVv7CbW/26zkTuaZV6vtdJjSo=";
  };

  buildInputs = [
    zig
    wayland
    wayland-protocols
    wlroots_12
    libxkbcommon
    libudev
    libevdev
    xorg.libX11
    pixman
    libGL
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildPhase = ''
    export HOME=$TMPDIR
    zig build -Drelease-safe=true
  '';

  installPhase = ''
    zig build -Drelease-safe=true --prefix $out install
  '';
}
