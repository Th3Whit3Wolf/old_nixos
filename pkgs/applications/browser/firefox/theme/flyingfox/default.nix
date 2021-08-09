{ lib
, stdenv
, source
, pkgs
, configCss ? ""
, treeStyleTabCss ? ""
}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  installPhase =
    ''
      mkdir -p $out/chrome
      cp -r chrome/* $out/chrome
      ${lib.optionalString (configCss != "")
      ''
      echo "${configCss}" > $out/chrome/config.css
      ''}
      ${lib.optionalString (treeStyleTabCss != "")
      ''
      echo "${treeStyleTabCss}" > $out/chrome/tree-style-tab.css
      ''}
    ''
  ;

  meta = with lib; {
    description = "An opinionated set of configurations for firefox";
    homepage = "https://flyingfox.netlify.app";
    license = licenses.mit;
    maintainers = [ th3whit3wolf ];
    platforms = platforms.all;
  };
}
