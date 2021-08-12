# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl }:
{
  QtGreet = {
    pname = "QtGreet";
    version = "07bb3e25563c2bbcb75cdd7330e269ad362a3b81";
    src = fetchgit {
      url = "https://gitlab.com/marcusbritanicus/QtGreet.git";
      rev = "07bb3e25563c2bbcb75cdd7330e269ad362a3b81";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1cwwn82418ylv8savby6yd98vi8kxbs83sglfssid32df4rw84s2";
    };
  };
  SFMono-nerdfont = {
    pname = "SFMono-nerdfont";
    version = "dc6cd76df1e864af4ac4fd9e529014648bb80f3c";
    src = fetchgit {
      url = "https://github.com/epk/SF-Mono-Nerd-Font";
      rev = "dc6cd76df1e864af4ac4fd9e529014648bb80f3c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0npnkff1s5ag4nv6gab5y14zyq19bh2vbd3c60sa2bk9razb2ljh";
    };
  };
  any-nix-shell = {
    pname = "any-nix-shell";
    version = "ea04f9bd639f175002127ad1b5715bce3d4bd9c5";
    src = fetchgit {
      url = "https://github.com/haslersn/any-nix-shell";
      rev = "ea04f9bd639f175002127ad1b5715bce3d4bd9c5";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0q27rhjhh7k0qgcdcfm8ly5za6wm4rckh633d0sjz87faffkp90k";
    };
  };
  eww = {
    pname = "eww";
    version = "8556e1539576fd39a89500d59acde4b523e9f716";
    src = fetchgit {
      url = "https://github.com/elkowar/eww";
      rev = "8556e1539576fd39a89500d59acde4b523e9f716";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0qs63k7m0675jwvpgkvdmza9csvhzl5r5agvh6s2zjfp8fa3414b";
    };
    cargoLock = {
      lockFile = ./eww-8556e1539576fd39a89500d59acde4b523e9f716/Cargo.lock;
      outputHashes = { };
    };
  };
  flyingfox = {
    pname = "flyingfox";
    version = "8fc00aa654c10260deac2cbbc5bf062b7dcce811";
    src = fetchgit {
      url = "https://github.com/akshat46/FlyingFox";
      rev = "8fc00aa654c10260deac2cbbc5bf062b7dcce811";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0z6q2953cbxngnzbpd0map2r89dywg3xjagav1qzzbpkyqck32w9";
    };
  };
  manix = {
    pname = "manix";
    version = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
    src = fetchgit {
      url = "https://github.com/mlvzk/manix";
      rev = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1b7xi8c2drbwzfz70czddc4j33s7g1alirv12dwl91hbqxifx8qs";
    };
    cargoLock = {
      lockFile = ./manix-d08e7ca185445b929f097f8bfb1243a8ef3e10e4/Cargo.lock;
      outputHashes = { };
    };
  };
  nbfc-linux = {
    pname = "nbfc-linux";
    version = "c78a639c895ed97550f67a2d872d4985fbda0904";
    src = fetchgit {
      url = "https://github.com/nbfc-linux/nbfc-linux";
      rev = "c78a639c895ed97550f67a2d872d4985fbda0904";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1h41szkwhxqc9fhrljc20gizykqkzxzllw8xibazmf5wyy4f058l";
    };
  };
  rainfox = {
    pname = "rainfox";
    version = "d373dc136b805097f5092d02365a90327dc1de4a";
    src = fetchgit {
      url = "https://github.com/1280px/rainfox";
      rev = "d373dc136b805097f5092d02365a90327dc1de4a";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1g39n3gzqq4hgic3w4n20fs8cz4a855scbnmah8pypz3amsnqzr5";
    };
  };
  rice = {
    pname = "rice";
    version = "3828474ea40e1c546bffedf6dee94bf3c880ce65";
    src = fetchgit {
      url = "https://github.com/themadprofessor/rice";
      rev = "3828474ea40e1c546bffedf6dee94bf3c880ce65";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1gjmfj5cxzdybmw1qqzc09la8ri1azdc5q7x91cn2ykw0f9jfpi9";
    };
  };
  sanFrancisco-font = {
    pname = "sanFrancisco-font";
    version = "bd895dae758c135851805087f68bef655fdc160c";
    src = fetchgit {
      url = "https://github.com/supermarin/YosemiteSanFranciscoFont";
      rev = "bd895dae758c135851805087f68bef655fdc160c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0fmcjv54q9j06494zf2p09z80gr4hgr7hqw6gavpvfzqp3hln661";
    };
  };
  sanFranciscoMono-font = {
    pname = "sanFranciscoMono-font";
    version = "1409ae79074d204c284507fef9e479248d5367c1";
    src = fetchgit {
      url = "https://github.com/supercomputra/SF-Mono-Font";
      rev = "1409ae79074d204c284507fef9e479248d5367c1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1yi3nqqs3lp6kkc2a5bvmmcq6j3ppkdmywsbiqcb79qyhhrvf0fz";
    };
  };
  spacemacs-theme = {
    pname = "spacemacs-theme";
    version = "f3dbdfba0207e7bb7a14f9e925c31c113eb11563";
    src = fetchgit {
      url = "https://github.com/Th3Whit3Wolf/Space-Theme";
      rev = "f3dbdfba0207e7bb7a14f9e925c31c113eb11563";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1c9vm5gfhgsslm0a1rpsh822938pjcpzqcy183xmhysv0k8jayxb";
    };
  };
  vimP-parinfer-rust = {
    pname = "vimP-parinfer-rust";
    version = "0789c4852d09d51ad66b81c44ce2575f421cd031";
    src = fetchgit {
      url = "https://github.com/eraserhd/parinfer-rust";
      rev = "0789c4852d09d51ad66b81c44ce2575f421cd031";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1y6y2k6kmj6xkng3vkh7pkgdggcb6hszdrihjbk9spb40l0na5l8";
    };
  };
  vimPlugins-ron-vim = {
    pname = "vimPlugins-ron-vim";
    version = "04004b3395d219f95a533c4badd5ba831b7b7c07";
    src = fetchgit {
      url = "https://github.com/ron-rs/ron.vim";
      rev = "04004b3395d219f95a533c4badd5ba831b7b7c07";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1xlr8slwcr6b9p33awf8xzdp04myv6dcsxwi50val4vzvzcgyrcl";
    };
  };
  vimPlugins-vim-cargo-make = {
    pname = "vimPlugins-vim-cargo-make";
    version = "9f36abd5b6b94bf12af44f6210b5f8836509ff69";
    src = fetchgit {
      url = "https://github.com/nastevens/vim-cargo-make";
      rev = "9f36abd5b6b94bf12af44f6210b5f8836509ff69";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "11vi7nmisyas27bp8fywq4qgmpdaix9bap2r9i86ip9mjajq96hv";
    };
  };
  vimPlugins-vim-duckscript = {
    pname = "vimPlugins-vim-duckscript";
    version = "3f3683132576cae15c470ac157fc1f6674c563f6";
    src = fetchgit {
      url = "https://github.com/nastevens/vim-duckscript";
      rev = "3f3683132576cae15c470ac157fc1f6674c563f6";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1361mn5zxv086r26fn95hc8nkjwq6zmjimvxbxaj9c91pqx90rhg";
    };
  };
  widevine-cdm = {
    pname = "widevine-cdm";
    version = "4.10.2209.1";
    src = fetchurl {
      url = "https://dl.google.com/widevine-cdm/4.10.2209.1-linux-x64.zip";
      sha256 = "1mnbxkazjyl3xgvpna9p9qiiyf08j4prdxry51wk8jj5ns6c2zcc";
    };
  };
}
