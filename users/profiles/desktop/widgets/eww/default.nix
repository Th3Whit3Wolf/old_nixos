{ config, lib, pkgs, ... }:

let
  /*
    * flattenTree & rakeLeaves were stolen from divinx/digga
    * https://github.com/divnix/digga/blob/13958d2b97263356e5661b9e2958e1e4730e12fd/src/importers.nix
  */

  flattenTree =
    tree:
    let
      op = sum: path: val:
        let
          pathStr = builtins.concatStringsSep "." path; # dot-based reverse DNS notation
        in
        if builtins.isPath val then
          (sum // {
            "${pathStr}" = val;
          })
        else if builtins.isAttrs val then
          (recurse sum path val)
        else
          sum
      ;

      recurse = sum: path: val:
        builtins.foldl'
          (sum: key: op sum (path ++ [ key ]) val.${key})
          sum
          (builtins.attrNames val)
      ;
    in
    recurse { } [ ] tree;

  rakeLeaves =
    dirPath:
    let
      seive = file: type:
        # Only rake `.nix` files or directories
        (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory")
      ;

      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value =
          let
            path = dirPath + "/${file}";
          in
          if (type == "regular")
            || (type == "directory" && builtins.pathExists (path + "/default.nix"))
          then path
          # recurse on directories that don't contain a `default.nix`
          else rakeLeaves path;
      };

      files = lib.filterAttrs seive (builtins.readDir dirPath);
    in
    lib.filterAttrs (n: v: v != { }) (lib.mapAttrs' collect files);

  paths = lib.mapAttrsToList (name: value: value) (flattenTree (rakeLeaves ./definitions));
  recursiveUpdateAttrsFromList = orig: listOfAttrs:
    if (listOfAttrs == [ ]) then
      orig
    else
      recursiveUpdateAttrsFromList (lib.recursiveUpdate orig (lib.head listOfAttrs)) (lib.drop 1 listOfAttrs);
  defsAttr = lib.mapAttrs' (name: value: lib.nameValuePair (builtins.replaceStrings [ "." ] [ "-" ] name) (value)) (flattenTree (rakeLeaves ./definitions));
  varAttrs =
    let
      varAttrs' = lib.remove { } (lib.forEach paths (x:
        if builtins.hasAttr "vars" (import x { lib = lib; pkgs = pkgs; }) then
          (import x { lib = lib; pkgs = pkgs; }).vars
        else
          { }
      ));
    in
    recursiveUpdateAttrsFromList { } varAttrs';
  scriptVarAttrs =
    let
      scriptVarAttrs' = lib.remove { } (lib.forEach paths (x:
        if builtins.hasAttr "script-vars" (import x { lib = lib; pkgs = pkgs; }) then
          (import x { lib = lib; pkgs = pkgs; }).script-vars
        else
          { }
      ));
    in
    recursiveUpdateAttrsFromList { } scriptVarAttrs';

  defs = lib.forEach
    (
      lib.mapAttrsToList (n: v: n) defsAttr
    )
    (x:
      ''<def name="${x}">
    ${(import defsAttr.${x} { lib = lib; pkgs = pkgs; }).def}
    </def>''
    );



  toPx = s: ''${builtins.toString s}px'';
  barH = 21;
  widgetH = barH + 4;
  widgetHeight = toPx widgetH;

  barHeight = toPx barH;
in
{
  config = {
    home = {
      file.".cache/face.png" = {
        source = ./face.png;
      };
      packages = [
        pkgs.tiramisu
        pkgs.SFMono-nerdfont
        pkgs.procps
      ];
    };
    xdg.configFile."eww/extra" = {
      source = ./extra;
      recursive = true;
    };
    fonts.fontconfig.enable = true;
    services.eww = {
      enable = true;
      isWayland = true;
      style = ./eww.scss;
      config = {
        definitions = defs;
        variables = {
          script-vars = { } // scriptVarAttrs;
          vars = {
            notificationBool = "false";
            notificationsContent = "";
            userIMG = "/persist/home/doc/Pics/Start/anarchy-linux-icon-arch-linux-menu-icon-11553405183t9efc972tu.png";
          } // varAttrs;
        };
        windows = {
          bar = {
            stacking = "bt";
            focusable = false;
            exclusive = true;
            geometry = {
              anchor = "top center";
              x = "0px";
              y = "0px";
              width = "100%";
              height = barHeight;
            };
            widget = "bar";
          };
          sidebar = {
            geometry = {
              anchor = "top right";
              x = "0px";
              y = barHeight;
              width = "500px";
              height = "50%";
            };
            widget = "sidebar";
          };
          notification = {
            geometry = {
              anchor = "top right";
              x = "0px";
              y = barHeight;
              width = "400px";
              height = "0px";
            };
            stacking = "fg";
            widget = "notifications-widget";
          };
        };
      };
    };
  };
}
