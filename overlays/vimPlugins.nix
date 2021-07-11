final: prev: {
  vimPlugins = with final.vimUtils;
    prev.vimPlugins // {
      vim-cargo-make = buildVimPluginFrom2Nix {
        inherit (prev.sources.vimPlugins-vim-cargo-make) version src;
        pname = removePrefix "vimPlugins-" prev.sources.vimPlugins-vim-cargo-make.pname
      };
    };
}
