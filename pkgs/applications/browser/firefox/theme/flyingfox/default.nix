{ lib
, stdenv
, source
, configCss ? ""
, treeStyleTabCss ? ""
}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  installPhase =
    ''
      cp -r ./chrome $out
      cp -r ./treestyletab $out/chrome
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
    maintainers = [ danielphan2003 ];
    platforms = platforms.all;
  };
}
