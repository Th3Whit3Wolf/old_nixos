{ lib
, stdenv
, pkgs
, flyingfox
, rainfox
, firefox-mod-blur
, withUrlbarBlur ? true
, withFlyingFox ? true
, withHideForwardNav ? true
, flyingFoxConfigCss ? ""
, flyingFoxTreeStyleTabCss ? ""
, navigatorToolboxColor ? "#77777773"
, urlbarAutocompletePopupColor ? "#313131ad"
, urlbarInputContainerPadding ? "8px"
, urlbarBorderBottom ? "1px solid #ffffff30"
, urlbarBorderRadius ? "12px 12px 12px 12px"
, urlbarBackgroundColor ? "#0000004d"
, megabarBackgroundColor ? "#1e1e1ebf"
, toolboxBackgroundColor ? "#333333"
, toolbarIcons ? "#ffffff"
, toolbarIconsDisabled ? "#333333"
}:

let
  flyingfoxFinal =
    if (flyingFoxConfigCss != "" || flyingFoxTreeStyleTabCss != "") then
      flyingfox.override { configCss = flyingFoxConfigCss; treeStyleTabCss = flyingFoxTreeStyleTabCss; }
    else
      flyingfox;
  userChrome = pkgs.writeText "userChrome.css" ''
    ${lib.optionalString withHideForwardNav ''@import "rainfox/userChromeNavButtons.css";''}
    ${lib.optionalString withFlyingFox ''@import "flyingfox/userChrome.css";''}
    ${lib.optionalString withUrlbarBlur ''
    /*
      From https://github.com/datguypiko/Firefox-Mod-Blur
    */

    /* Search Bar #2b2b2bd1 262626ed #1E1E1EBF*/
    #urlbar {
      /*--autocomplete-popup-highlight-background: transparent !important;*/
      --autocomplete-popup-highlight-background: ${urlbarAutocompletePopupColor};
    }

    #urlbar-container {
      border-radius: ${urlbarBorderRadius} !important;
      /* padding-top: 0px !important;
        padding-bottom: 0px !important;*/
    }
    #urlbar-input-container,
    #searchbar {
      border-radius: ${urlbarBorderRadius} !important;
    }

    .urlbarView-body-inner {
      border-top: 0px !important;
    }

    #urlbar-input-container {
      /* Fixing icons right and left padding inside search bar for hovering  */
      padding-left: ${urlbarInputContainerPadding};
      padding-right: ${urlbarInputContainerPadding};
    }
    #navigator-toolbox {
      --lwt-toolbar-field-border-color: transparent !important;
      --lwt-toolbar-field-focus: transparent !important;
      --toolbar-field-focus-border-color: ${navigatorToolboxColor} !important;
    }

    #urlbar:not(.megabar):not([focused="true"]):-moz-lwtheme,
    #urlbar:not(.megabar):not([focused="true"]):-moz-lwtheme:hover {
      border-color: transparent;
    }
    #urlbar {
      border: 0 !important;
      border-bottom: ${urlbarBorderBottom} !important;
      border-radius: ${urlbarBorderRadius} !important;
      background-color: ${urlbarBackgroundColor};
    }
    #urlbar {
      box-shadow: none !important;
    }
    #tracking-protection-icon-container {
      border-inline-end: none !important;
      border-image: none !important;
    }
    #urlbar[breakout] {
      height: auto !important;
    }
    /* Megabar */
    #urlbar[breakout][breakout-extend][open] {
      background-image: url(firefox-mod-blur/image/noise-512x512.png) !important;
      background-color: ${megabarBackgroundColor} !important;
      -webkit-backdrop-filter: blur(32px) !important;
      backdrop-filter: blur(32px) !important;
    }

    #urlbar[breakout][breakout-extend] > #urlbar-input-container,
    #urlbar-input-container {
      height: var(--urlbar-height) !important;
      padding-block: 0px !important;
      padding-inline: 0px !important;
      transition: none !important;
    }
    #urlbar[breakout][breakout-extend] {
      top: calc(
        (var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2
      ) !important;
      left: 0 !important;
      width: 100% !important;
    }

    #urlbar .urlbar-input-box {
        text-align: center;
    }

    /* Hide the reload button by default */
    #reload-button {
      transition: 150 !important; /* Animate icon hiding */
      opacity: 0 !important; /* Make icon transparent */
      -moz-margin-end: -2em !important; /* Hide icon by offsetting it */
    }

    /* Show the reload button on navbar hover or page load (animation/stop button) */
    #nav-bar:hover #reload-button,
    #stop-reload-button[animate] > #reload-button:not([displaystop]) {
      transition: 150ms !important; /* Animate icon showing */
      opacity: 1 !important;  /* Make the icon opaque */
      -moz-margin-end: initial !important; /* Use initial margins to show the icon */
    }

    html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar {
      background-color: ${toolboxBackgroundColor} !important;
    }

    :root {
      --toolbar-bgimage: none !important;
    }

    html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container {
      border: none !important;
    }

    html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar {
      border: none !important;
    }

    .toolbarbutton-animatable-box, .toolbarbutton-1 {
      fill: ${toolbarIcons};
    }

    toolbarbutton:where([disabled="true"]) {
      color: ${toolbarIconsDisabled};
    }

    ''}
  '';
  userContent = pkgs.writeText "userContent.css" ''
    /* in userContent for all the about:pages of firefox */
    *{
        scrollbar-width: 3px !important;
    }
  '';
in

stdenv.mkDerivation rec {
  pname = "firefoxUserChrome";
  version = "0.0.1";

  unpackPhase = "true";
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/chrome
    ln -s ${userChrome}  $out/chrome/userChrome.css
    ln -s ${userContent} $out/chrome/userContent.css
    ${lib.optionalString withUrlbarBlur ''ln -s ${firefox-mod-blur}/chrome $out/chrome/firefox-mod-blur''}
    ${lib.optionalString withFlyingFox ''ln -s ${flyingfoxFinal}/chrome $out/chrome/flyingfox''}
    ${lib.optionalString withHideForwardNav ''ln -s ${rainfox}/chrome $out/chrome/rainfox''}
  '';

  meta = with lib; {
    description = "An opinionated set of configurations for firefox";
    license = licenses.mit;
    maintainers = [ th3whit3wolf ];
    platforms = platforms.all;
  };
}
