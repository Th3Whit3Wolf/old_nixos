{ makeRustPlatform, pkgs }:

{ date, channel }:

let
  rustSpecific = (pkgs.rustChannelOf { inherit date channel; }).default;
in
makeRustPlatform
{
  cargo = rustSpecific;
  rustc = rustSpecific;
}
