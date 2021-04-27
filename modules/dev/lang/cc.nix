# modules/dev/cc.nix --- C & C++
#
# I love C. I tolerate C++. I adore C with a few choice C++ features tacked on.
# Liking C/C++ seems to be an unpopular opinion. It's my guilty secret, so don't
# tell anyone pls.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.lang.cc;
in {
  options.modules.dev.lang.cc = {
    enable = mkBoolOpt false;
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [
        ms-vscode.cpptools
        llvm-org.lldb-vscode
        ccls-project.ccls
      ]);
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      clang
      gcc
      musl
      #      bear
      gdb
      cmake
      cmake-language-server
      llvmPackages.libcxx
      ccls
      ccache
      fmt
    ];
    env.CCACHE_DIR = "$XDG_CACHE_HOME/ccache";
    env.CCACHE_CONFIGPATH = "$XDG_CONFIG_HOME/ccache.config";

    home.dataFile = {
      "nvim/site/ftplugin/c.vim".text = ''
let b:endwise_addition = '#endif'
let b:endwise_words = 'if,ifdef,ifndef'
let b:endwise_pattern = '^\s*#\%(if\|ifdef\|ifndef\)\>'
let b:endwise_syngroups = 'cPreCondit,cPreConditMatch,cCppInWrapper,xdefaultsPreProc'

function! CompileMyCode()
    call Run("${pkgs.gcc}/bin/gcc % -o %< -Wall -Wextra -Wshadow -Wdouble-promotion -Wformat=2 -Wformat-truncation -Wformat-overflow -Wundef -fno-common -ffunction-sections -fdata-sections -O0")
endfunction

function! RunMyCode()
    call Run("${pkgs.gcc}/bin/gcc % -o %<  -Wall -Wextra -Wshadow -Wdouble-promotion -Wformat=2 -Wformat-truncation -Wformat-overflow -Wundef -fno-common -ffunction-sections -fdata-sections -O0 ; ./%<")
endfunction

if !stridx(&rtp, resolve(expand('~/.config/nvim/lazy/vim-endwise.vim'))) == 0
    execute 'source' fnameescape(resolve(expand('~/.config/nvim/lazy/vim-endwise.vim')))
endif

imap <buffer> <CR> <CR><Plug>DiscretionaryEnd

lua require 'plugins.tree_sitter'
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
      '';
      "nvim/site/ftplugin/cmake.vim".text = ''
packadd vim-cmake-syntax

packadd vim-cmake
let b:endwise_addition = '\=submatch(0)==#toupper(submatch(0)) ? "END".submatch(0)."()" : "end".submatch(0)."()"'
let b:endwise_words = 'foreach,function,if,macro,while'
let b:endwise_pattern = '\%(\<end\>.*\)\@<!\<&\>'
let b:endwise_syngroups = 'cmakeStatement,cmakeCommandConditional,cmakeCommandRepeat,cmakeCommand'

if !stridx(&rtp, resolve(expand('~/.config/nvim/lazy/vim-endwise.vim'))) == 0
    execute 'source' fnameescape(resolve(expand('~/.config/nvim/lazy/vim-endwise.vim')))
endif

imap <buffer> <CR> <CR><Plug>DiscretionaryEnd
      '';
      "nvim/site/ftplugin/cpp.vim".text = ''
	let b:endwise_addition = '#endif'
let b:endwise_words = 'if,ifdef,ifndef'
let b:endwise_pattern = '^\s*#\%(if\|ifdef\|ifndef\)\>'
let b:endwise_syngroups = 'cPreCondit,cPreConditMatch,cCppInWrapper,xdefaultsPreProc'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

let c_no_curly_error=1

function! CompileMyCode()
    call Run("${pkgs.gcc}/bin/g++ -std=c++17 % -o %< -Wall -Wextra -Wshadow -Wdouble-promotion -Wformat=2 -Wformat-truncation -Wformat-overflow -Wundef -fno-common -ffunction-sections -fdata-sections -O0")
endfunction
function! RunMyCode()
    call Run("${pkgs.gcc}/bin/g++ -std=c++17 % -o %< -Wall -Wextra -Wshadow -Wdouble-promotion -Wformat=2 -Wformat-truncation -Wformat-overflow -Wundef -fno-common -ffunction-sections -fdata-sections -O0; ./%<")
endfunction

if !stridx(&rtp, resolve(expand('~/.config/nvim/lazy/vim-endwise.vim'))) == 0
    execute 'source' fnameescape(resolve(expand('~/.config/nvim/lazy/vim-endwise.vim')))
endif

imap <buffer> <CR> <CR><Plug>DiscretionaryEnd

lua require 'plugins.tree_sitter'
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
      '';
    };
  };
}
