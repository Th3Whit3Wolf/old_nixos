final: prev: 
{
  vimPlugins = with final.vimUtils;
  prev.vimPlugins // {
    vim-cargo-make = buildVimPluginFrom2Nix {
      pname = srcs.vim-cargo-make.pname;
      version = srcs.vim-cargo-make.version;
      src = srcs.vim-cargo-make;
    };
  };
}
