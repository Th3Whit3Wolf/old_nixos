rec {
  hasInfix = infix: content: with builtins;
    let
      drop = x: substring 1 (stringLength x) x;
    in
    hasPrefix infix content
    || content != "" && hasInfix infix (drop content);

  hasPrefix = pref: str: with builtins;
    substring 0 (stringLength pref) str == pref;

  hasSuffix = suffix: content: with builtins;
    let
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix &&
    substring (lenContent - lenSuffix) lenContent content == suffix;

  removePrefix = prefix: str: with builtins;
    let
      preLen = stringLength prefix;
      sLen = stringLength str;
    in
    if hasPrefix prefix str then
      substring preLen (sLen - preLen) str
    else
      str;

  removeSuffix = suffix: str: with builtins;
    let
      sufLen = stringLength suffix;
      sLen = stringLength str;
    in
    if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str then
      substring 0 (sLen - sufLen) str
    else
      str;

  filterAttrs = pred: set: with builtins;
    listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [ (nameValuePair name v) ] else [ ]) (attrNames set));

  nameValuePair = name: value: { inherit name value; };

  mapAttrs' = f: set: with builtins;
    listToAttrs (map (attr: f attr set.${attr}) (attrNames set));

  forEach = xs: f: map f xs;

  splitString = _sep: _s: with builtins;
    let
      sep = unsafeDiscardStringContext _sep;
      s = unsafeDiscardStringContext _s;
      splits = filter isString (split (escapeRegex sep) s);
    in
    map (v: addContextFrom _sep (addContextFrom _s v)) splits;

  addContextFrom = a: b: with builtins;
    substring 0 0 a + b;

  escapeRegex = with builtins;
    escape (stringToCharacters "\\[{()^$?*+|.");

  escape = list: with builtins;
    replaceStrings list (map (c: "\\${c}") list);

  stringToCharacters = s: with builtins;
    map (p: substring p 1 s) (range 0 (stringLength s - 1));

  range = first: last: with builtins;
    if first > last then
      [ ]
    else
      genList (n: first + n) (last - first + 1);

  last = list: with builtins;
    elemAt list (length list - 1);

  rakeLeaves = dirPath: with builtins;
    let
      seive = file: type:
        # Only rake `.nix` files or directories
        (type == "regular" && hasSuffix ".nix" file) || (type == "directory");

      collect = file: type: {
        name = removeSuffix ".nix" file;
        value =
          let
            path = dirPath + "/${file}";
          in
          if (type == "regular")
            || (type == "directory" && pathExists (path + "/default.nix"))
          then path
          # recurse on directories that don't contain a `default.nix`
          else rakeLeaves path;
      };

      files = filterAttrs seive (readDir dirPath);
    in
    filterAttrs (n: v: v != { }) (mapAttrs' collect files);

  flattenTree = tree: with builtins;
    let
      op = sum: path: val:
        let
          pathStr = concatStringsSep "." path; # dot-based reverse DNS notation
        in
        if isPath val then
        # builtins.trace "${toString val} is a path"
          (sum // {
            "${pathStr}" = val;
          })
        else if isAttrs val then
        # builtins.trace "${builtins.toJSON val} is an attrset"
        # recurse into that attribute set
          (recurse sum path val)
        else
        # ignore that value
        # builtins.trace "${toString path} is something else"
          sum
      ;

      recurse = sum: path: val:
        foldl'
          (sum: key: op sum (path ++ [ key ]) val.${key})
          sum
          (attrNames val)
      ;
    in
    recurse { } [ ] tree;

  rakePkgs = dir: with builtins;
    let
      sieve = name: val:
        if isAttrs val then
          all (x: x == true)
            (forEach (attrNames val) (v:
              hasInfix "_sources" v
            ))
        else
          (val != ./default.nix && name != "bud");
    in
    mapAttrs' (name: value: nameValuePair (last (splitString "." name)) (value)) (flattenTree (filterAttrs sieve (rakeLeaves dir))
    );

  mapPkgSets = sources: pkgSet: pkgSetName: buildTool:
    let
      prefix = pkgSetName + "-";
      newPkgs = mapAttrs' (name: value: nameValuePair (removePrefix prefix name) (value)) (filterAttrs (n: v: hasPrefix prefix n) sources);
      createNewPkgs = pname: version: src: buildTool { inherit pname version src; };
      overridePkgVersionSrc = pkg: version: src: pkg.overrideAttrs (_: { inherit version src; });
      overrideOrCreatePkg = pkgFromSet:
        let
          pname = removePrefix prefix pkgFromSet.pname;
          pkg = pkgSet.${pname} or { };
          version = pkgFromSet.version;
          src = pkgFromSet.src;
        in
        if pkg ? overrideAttrs
        then overridePkgVersionSrc pkg version src
        else createNewPkgs pname version src;

      mapPackages = set: mapAttrs'
        (name: src: nameValuePair name (overrideOrCreatePkg set.${name}))
        set;
    in
    pkgSet // mapPackages newPkgs;

  overlaySrc = final: prev: {
    sources = (import ./_sources/generated.nix) { inherit (final) fetchurl fetchgit; };
  };

  overlayLocal = final: prev: builtins.mapAttrs
    (name: value:
      let
        sources = (import ./_sources/generated.nix) { inherit (final) fetchurl fetchgit; };
        package = import (value);
        args = builtins.intersectAttrs (builtins.functionArgs package) { source = sources.${name}; };
      in
      final.callPackage package args
    )
    (rakePkgs (./.));

  overlayPkgsSets = final: prev: {
    sources = (import ./_sources/generated.nix);

    vimPlugins = mapPkgSets prev.sources prev.vimPlugins "vimPlugins" prev.vimUtils.buildVimPluginFrom2Nix;
  };

  overlay = [ overlaySrc overlayLocal overlayPkgsSets ];
}
