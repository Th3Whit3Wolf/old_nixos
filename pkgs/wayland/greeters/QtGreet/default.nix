{ lib
, source
, stdenv
, cmake
, extra-cmake-modules
, ninja
, pkg-config
, wayland
, libsForQt5
, pkgs
}:

(libsForQt5.callPackage ({ mkDerivation }: mkDerivation) { } rec {
  inherit (source) pname version src;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    extra-cmake-modules
    libsForQt5.qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5.qttools
    pkgs.dbus
  ];

  patches = [
    ./cmake.patch
  ];

  cmakeFlags = [
    "-GNinja"
  ];


  meta = with lib; {
    description = "Qt based greeter for greetd";
    homepage = "https://gitlab.com/marcusbritanicus/QtGreet";
    maintainers = with maintainers; [ th3whit3wolf ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
})

/*


*/
