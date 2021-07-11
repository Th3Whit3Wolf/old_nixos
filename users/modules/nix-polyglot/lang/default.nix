{ pkgs, lib, ... }:
let
  /*
  cfg = cfg = config.nix-polyglot;
  editors = [ 
    lib.optionalString cfg.vscode.enable "vscode"
    lib.optionalString cfg.neovim.enable "neovim"
  ];
    editorFilter = key: value: 
  if (editors != []) then (value == "directory" && (elem key editors || key == "default") || value == "file" && (elem (removeSuffix ".nix" key) editors))
  else [];
  folder = ./.;
  toImportLang = name: value: folder + ("/" + name);
  toImportEditor = lang: name: value: folder + ("/" + name);

  filterCaches = key: value: value == "directory" && (elem key cfg.langs || elem "all" cfg.langs || key == "default");
  langList = lib.mapAttrsToList toImportLang
    (lib.filterAttrs filterCaches (builtins.readDir folder));

  getImports = lang: lib.mapAttrsToList toImportEditor lang
    (lib.filterAttrs editorFilter (builtins.readDir (toImportLang langList)));
  optional cfg.${editor}.enable ++ (lib.optionalString [isPath / + "${lang}/default.nix"] lang)
  
  imports = [./default] ++ (flatten (forEach langList (lang: lib.mapAttrsToList toImportEditor lang
    (lib.filterAttrs editorFilter (builtins.readDir (toImportLang langList)));
  optional cfg.${editor}.enable ++ (lib.optionalString [isPath / + "${lang}/default.nix"] lang)) );
  */
  folder = ./.;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "directory";
  imports = lib.mapAttrsToList toImport
    (lib.filterAttrs filterCaches (builtins.readDir folder));
in { inherit imports; }

/* 
  New Folder structure
  lang/${programmingLanguage}/${editor}
  lang/${programmingLanguage}/${editor}.nix

  ${editor} settings for a ${programmingLanguage} and/or settings for plugins/extensions 
*/
