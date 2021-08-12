{ lib
, stdenv
, source
, pkgs
, configCss ? ""
, treeStyleTabCss ? ""
}:

let
  newWc = pkgs.writeText "wc-without-tabline.css" ''
    @import "window-controls.css";

    /*
    :root:not([inFullscreen]) toolbar#nav-bar {
        z-index: 1 !important;
        position: relative !important;
        margin-left: calc(
            var(--wc-right-space) * 2 + 60px
        ) !important; /* shift toolbar to the right based on initial width */
    }
    */

    #TabsToolbar .toolbar-items {
        display: none !important;
    }

    .titlebar-buttonbox {
        flex-direction: row-reverse;
    }

    /*
    #TabsToolbar.browser-toolbar {
        display: inline-block !important;
        position: absolute;
        top: var(--wc-vertical-shift) !important;
        left: var(--wc-left-space) !important;
    }
    */

  '';
in
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  #patches = [ ./no-tabline.patch ];
  installPhase =
    ''
      cp -r ./ $out
      cat ${newWc} > wc-without-tabline.css
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
