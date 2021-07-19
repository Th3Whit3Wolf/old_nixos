final: prev:

{
  vscode-extensions = with final.vscode-utils;
    prev.vscode-extensions // {
      roscop.activefileinstatusbar = extensionFromVscodeMarketplace {
        name = "ActiveFileInStatusBar";
        publisher = "RoscoP";
        version = "1.0.3";
        sha256 = "5GJODdKL8949a8KR2O7hGsRgAknfPyNEJ+9aiEYYemk=";
      };
      cometeer.spacemacs = extensionFromVscodeMarketplace {
        name = "spacemacs";
        publisher = "cometeer";
        version = "1.1.1";
        sha256 =
          "da54d2a40b72bb814b2e4af6b03eff6b3982162ae6f4492e6ceccad8f70cc7d3";
      };
      spikespaz.vscode-smoothtype = extensionFromVscodeMarketplace {
        name = "vscode-smoothtype";
        publisher = "spikespaz";
        version = "1.2.0";
        sha256 =
          "5f6143f92b7b8d9cf012482d1dac8ac4c821df62c6f89cc1871a76795e15e5f6";
      };
      ms-vscode-remote.remote-ssh = extensionFromVscodeMarketplace {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "04niirbkrzsm4wk22pr5dcfymnhqq4vn25xwkf5xvbpw32v1bpp3";
      };
      ms-vscode-remote.remote-ssh-edit = extensionFromVscodeMarketplace {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      };
      aaron-bond.better-comments = extensionFromVscodeMarketplace {
        name = "better-comments";
        publisher = "aaron-bond";
        version = "2.1.0";
        sha256 =
          "97b306d9ba5f4e05600bec4b6a5eb281bc6bad1a0d38dcce5a3b377d9799b54e";
      };
      wwm.better-align = extensionFromVscodeMarketplace {
        name = "better-align";
        publisher = "wwm";
        version = "1.1.6";
        sha256 =
          "909262fb423f6426d698b47cceb84c00b6342f010c30cefff098f6a4b6babbd1";
      };
      christian-kohler.path-intellisense = extensionFromVscodeMarketplace {
        name = "path-intellisense";
        publisher = "christian-kohler";
        version = "1.4.2";
        sha256 = "0i2b896cnlk1d23w3jgy8wdqsww2lz201iym5c1rqbjzg1g3v3r4";
      };
      hardikmodha.create-tests = extensionFromVscodeMarketplace {
        name = "create-tests";
        publisher = "hardikmodha";
        version = "1.1.1";
        sha256 =
          "14c1166bc9901f3a9d0299d0e27787bf76fbabedeb0c2bc5719daec65a024666";
      };
      softwaredotcom.swdc-vscode = extensionFromVscodeMarketplace {
        name = "swdc-vscode";
        publisher = "softwaredotcom";
        version = "2.5.8";
        sha256 =
          "52795a7fe0eed906e22df96fddd5bad3c2c180b1e6eedc49f6ac233ceff0fdf5";
      };
      ryu1kn.edit-with-shell = extensionFromVscodeMarketplace {
        name = "edit-with-shell";
        publisher = "ryu1kn";
        version = "1.2.0";
        sha256 =
          "e75a454824d41c9edd04014857e020b36a1f13a40ebd9d8506ef93b3ee9946ec";
      };
      oderwat.indent-rainbow = extensionFromVscodeMarketplace {
        name = "indent-rainbow";
        publisher = "oderwat";
        version = "7.5.0";
        sha256 =
          "13131599d4b2755ea84f98e2b27a7ddefe8e5e1eb09492bc291492fa0ca9a17e";
      };
      KnisterPeter.vscode-github = extensionFromVscodeMarketplace {
        name = "vscode-github";
        publisher = "KnisterPeter";
        version = "0.30.5";
        sha256 =
          "e194e7fef17fb28ad435b6ebe062cff4b84dd76a2144bfe6cb644a09c6d1b596";
      };
      mikestead.dotenv = extensionFromVscodeMarketplace {
        name = "dotenv";
        publisher = "mikestead";
        version = "1.0.1";
        sha256 = "dieCzNOIcZiTGu4Mv5zYlG7jLhaEsJR05qbzzzQ7RWc=";
      };
      kruemelkatze.vscode-dashboard = extensionFromVscodeMarketplace {
        name = "vscode-dashboard";
        publisher = "kruemelkatze";
        version = "2.3.1";
        sha256 =
          "e83936e8fc562aafac3a379dc895a9b118604bfaf17a432959bdfbd419622248";
      };
      alefragnani.project-manager = extensionFromVscodeMarketplace {
        name = "project-manager";
        publisher = "alefragnani";
        version = "12.0.1";
        sha256 =
          "3bd8743734421338697fc2293132eb76672516d1bd8dde7fc8bc0ade029693ad";
      };
      shd101wyy.markdown-preview-enhanced = extensionFromVscodeMarketplace {
        name = "markdown-preview-enhanced";
        publisher = "shd101wyy";
        version = "0.5.15";
        sha256 = "uR6wX0L2ceI8iZJc6ZSxR+iVx0N1qd4dO3eVLE+X6d4=";
      };
      dendron.dendron = extensionFromVscodeMarketplace {
        name = "dendron";
        publisher = "dendron";
        version = "0.23.0";
        sha256 = "UnVF6pO7wsuumUm/Ge2xteM9tpsc17qqNALfb6ddyIk=";
      };
      eamodio.gitlens = extensionFromVscodeMarketplace {
        name = "gitlens";
        publisher = "eamodio";
        version = "11.1.3";
        sha256 = "hqJg3jP4bbXU4qSJOjeKfjkPx61yPDMsQdSUVZObK/U=";
      };
      rubbersheep.gi = extensionFromVscodeMarketplace {
        name = "gi";
        publisher = "rubbersheep";
        version = "0.2.11";
        sha256 =
          "d2e89c422e99169d4e0bffaea67bcebdc57f3557a54077fc8c5fa7922a373349";
      };
      vsls-contrib.gistfs = extensionFromVscodeMarketplace {
        name = "gistfs";
        publisher = "vsls-contrib";
        version = "0.2.6";
        sha256 =
          "6793efe58c0fa8658675daa0a5847cf2b6211bafb69f3dbe0f716851234272c1";
      };
      formulahendry.code-runner = extensionFromVscodeMarketplace {
        name = "code-runner";
        publisher = "formulahendry";
        version = "0.11.3";
        sha256 =
          "8a79f61425d5a07c492537eee39b7d0524cf8135219e99fdd276b6675ac2fcec";
      };
      donjayamanne.githistory = extensionFromVscodeMarketplace {
        name = "githistory";
        publisher = "donjayamanne";
        version = "0.6.16";
        sha256 =
          "69ed777acf90f61342198ad38ff9228fe59fa1b5a99adf16c168df868f9bbf95";
      };
      felipecaputo.git-project-manager = extensionFromVscodeMarketplace {
        name = "git-project-manager";
        publisher = "felipecaputo";
        version = "1.7.1";
        sha256 =
          "092a188e29f3c26694ad94581388a8d85d0094f9899c6ffa4a97e384f47ff0dd";
      };
      qezhu.gitlink = extensionFromVscodeMarketplace {
        name = "gitlink";
        publisher = "qezhu";
        version = "0.6.1";
        sha256 =
          "10158fdcb6f230547675bdf7b4fee94b879830eb6e3065222f74869bb5b3311e";
      };
      lamartire.git-indicators = extensionFromVscodeMarketplace {
        name = "git-indicators";
        publisher = "lamartire";
        version = "2.1.2";
        sha256 =
          "7e56c5eee0b693a5d8122376451156e1d011b82c0caf84f9cf000f6a05f66a8d";
      };
      erichbehrens.pull-request-monitor = extensionFromVscodeMarketplace {
        name = "pull-request-monitor";
        publisher = "erichbehrens";
        version = "1.7.1";
        sha256 =
          "08c88955a13dd757b01c988aa5f262992470a4490c7df7972384b6ee9c4fe117";
      };
      nash.awesome-flutter-snippets = extensionFromVscodeMarketplace {
        name = "awesome-flutter-snippets";
        publisher = "Nash";
        version = "2.0.4";
        sha256 = "p0/96R3Fg3Z12r3S9i7Vc4gN4kM2DhyTwCh+s2x3fRI=";
      };
      dzhavat.css-initial-value = extensionFromVscodeMarketplace {
        name = "css-initial-value";
        publisher = "dzhavat";
        version = "0.2.3";
        sha256 = "ILjKZcvobNfNPS/MjH9MO/QJfN/WE1YuixAG9SlIL74=";
      };
      dart-code.dart-code = extensionFromVscodeMarketplace {
        name = "dart-code";
        publisher = "Dart-Code";
        version = "3.18.0";
        sha256 = "E+qrY7wOvengOs2yKqhh+5dRLu3dUu6yWxGcwD7QHuI=";
      };
      dart-code.flutter = extensionFromVscodeMarketplace {
        name = "flutter";
        publisher = "Dart-Code";
        version = "3.18.0";
        sha256 = "nvKBPSe0+WQ8m88WrQqhzVrqYBjcBhiz6EuJ38gTFhQ=";
      };
      zignd.html-css-class-completion = extensionFromVscodeMarketplace {
        name = "html-css-class-completion";
        publisher = "Zignd";
        version = "1.20.0";
        sha256 = "3BEppTBc+gjZW5XrYLPpYUcx3OeHQDPW8z7zseJrgsE=";
      };
      mathiasfrohlich.kotlin = extensionFromVscodeMarketplace {
        name = "Kotlin";
        publisher = "mathiasfrohlich";
        version = "1.7.1";
        sha256 = "MuAlX6cdYMLYRX2sLnaxWzdNPcZ4G0Fdf04fmnzQKH4=";
      };
      alefragnani.pascal = extensionFromVscodeMarketplace {
        name = "pascal";
        publisher = "alefragnani";
        version = "9.2.0";
        sha256 = "mFNxz5qwClDeLtE1W9S6k7uSeXFVClHvIKD2QE1DmAE=";
      };
      alefragnani.pascal-formatter = extensionFromVscodeMarketplace {
        name = "pascal-formatter";
        publisher = "alefragnani";
        version = "2.4.0";
        sha256 = "cx8NfAEwneEWkoUoqEXSfvwNSYzRHSSKsH5kx0I5QWo=";
      };
      esbenp.prettier-vscode = extensionFromVscodeMarketplace {
        name = "prettier-vscode";
        publisher = "esbenp";
        version = "5.8.0";
        sha256 = "x6/bBeHi/epYpRGy4I8noIsnwFdFEXk3igF75y5h/EA=";
      };
      jeroen-meijer.pubspec-assist = extensionFromVscodeMarketplace {
        name = "pubspec-assist";
        publisher = "jeroen-meijer";
        version = "2.2.1";
        sha256 = "555vpI6QqP9bpfLFIH2whRsAjsnQnwOjMXAnCF0Y30E=";
      };
      ms-python.python = extensionFromVscodeMarketplace {
        name = "python";
        publisher = "ms-python";
        version = "2020.12.424452561";
        sha256 = "ji5MS4B6EMehah8mi5qbkP+snCoVQJC5Ss2SG1XjoH0=";
      };
      humao.rest-client = extensionFromVscodeMarketplace {
        name = "rest-client";
        publisher = "humao";
        version = "0.24.4";
        sha256 = "NUmjnPS4bJghCtU8a9RTKhqkxuwj2DTivlG5Ac8t/aU=";
      };
      adpyke.codesnap = extensionFromVscodeMarketplace {
        name = "codesnap";
        publisher = "adpyke";
        version = "1.2.0";
        sha256 = "rhpEN7h3cu5qKG+b+gIMB7zGXc2K64BVoEj6jqe0v3A=";
      };
      msjsdiag.vscode-react-native = extensionFromVscodeMarketplace {
        name = "vscode-react-native";
        publisher = "msjsdiag";
        version = "1.2.0";
        sha256 = "1ESN47fzDrK6keoZqGvauAeDNREl/C9wp2vcA86Jqp0=";
      };
      dbaeumer.vscode-eslint = extensionFromVscodeMarketplace {
        name = "vscode-eslint";
        publisher = "dbaeumer";
        version = "2.1.14";
        sha256 = "bVGmp871yu1Llr3uJ+CCosDsrxJtD4b1+CR+omMUfIQ=";
      };
      pflannery.vscode-versionlens = extensionFromVscodeMarketplace {
        name = "vscode-versionlens";
        publisher = "pflannery";
        version = "1.0.9";
        sha256 = "cPESnrSnCurVUEgPh6g4Tk7PY3K4du6w9pcOZUYf1bM=";
      };
      svelte.svelte-vscode = extensionFromVscodeMarketplace {
        name = "svelte-vscode";
        publisher = "svelte";
        version = "102.8.0";
        sha256 = "sopN6tYQiqsJ1Z/aiBOOjGckutkIQCwPGFnmw9BXN3g=";
      };
      rust-lang.rust = extensionFromVscodeMarketplace {
        name = "rust";
        publisher = "rust-lang";
        version = "0.7.8";
        sha256 = "Y33agSNMVmaVCQdYd5mzwjiK5JTZTtzTkmSGTQrSNg0=";
      };
      b4dm4n.nixpkgs-fmt = extensionFromVscodeMarketplace {
        name = "nixpkgs-fmt";
        publisher = "B4dM4n";
        version = "0.0.1";
        sha256 = "vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
      };
      jnoortheen.nix-ide = extensionFromVscodeMarketplace {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.10";
        sha256 =
          "91be833e4526dca49b1ecde5bce1f97c7bb86d466c44d00eabfa6691f21a3d31";
      };
      arrterian.nix-env-selector = extensionFromVscodeMarketplace {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "1.0.7";
        sha256 =
          "0e76885c9dbb6dca4eac8a75866ec372b948cc64a3a3845327d7c3ef6ba42a57";
      };
      rebornix.Ruby = extensionFromVscodeMarketplace {
        name = "Ruby";
        publisher = "rebornix";
        version = "0.28.1";
        sha256 =
          "1c051dbfed93fa7789e5a086890dfba423bac7aaf9ec72149cb9b86a983d2f9d";
      };
      misogi.ruby-rubocop = extensionFromVscodeMarketplace {
        name = "misogi";
        publisher = "ruby-rubocop";
        version = "0.8.5";
        sha256 =
          "8f1d6f453c330f841e123fd03e2d649a74bae2e4f67119951563b573e4ebdab6";
      };
      castwide.solargraph = extensionFromVscodeMarketplace {
        name = "solargraph";
        publisher = "castwide";
        version = "0.21.1";
        sha256 =
          "632cc6505452580fa5119920f15707b56e6026e6ba385e6456155446de35be95";
      };

      hridoy.rails-snippets = extensionFromVscodeMarketplace {
        name = "rails-snippets";
        publisher = "Hridoy";
        version = "1.08";
        sha256 = "0q3sw1i8qsm0czm359kgfjqksn928hclsbfgwrqqbcvi2037ya1r";
      };
      vortizhe.simple-ruby-erb = extensionFromVscodeMarketplace {
        name = "simple-ruby-erb";
        publisher = "vortizhe";
        version = "0.2.1";
        sha256 =
          "259a2fe3a41650721ec2ee0566d9502ffc1157aac7a6ee8a77dcae59d08befbc";
      };
      belfz.search-crates-io = extensionFromVscodeMarketplace {
        name = "search-crates-io";
        publisher = "belfz";
        version = "1.2.1";
        sha256 =
          "2b61f83871fabe042f86170e15d3f7443d1f3e0840c716e0babbfe37cda914db";
      };
      batisteo.vscode-django = extensionFromVscodeMarketplace {
        name = "vscode-django";
        publisher = "batisteo";
        version = "1.4.0";
        sha256 =
          "80161c799d9b1a82dd5500084d4d2d73829f05686bfb98d0576e69f47316b939";
      };
      CodeYard.flask-snippets = extensionFromVscodeMarketplace {
        name = "flask-snippets";
        publisher = "CodeYard";
        version = "1.1.0";
        sha256 =
          "d32bfe718adb0adf6b9b5e1de34c5424522291fc7b829717ce13fa6dd8b04a35";
      };
      frhtylcn.pythonsnippets = extensionFromVscodeMarketplace {
        name = "pythonsnippets";
        publisher = "frhtylcn";
        version = "1.0.2";
        sha256 =
          "6f9a105119619800f00e3b8ff0a1dfaaa4f5f794cca0886d548f3bb092dfd25c";
      };
      LittleFoxTeam.vscode-python-test-adapter =
        extensionFromVscodeMarketplace {
          name = "vscode-python-test-adapter";
          publisher = "LittleFoxTeam";
          version = "0.6.7";
          sha256 =
            "fe8afe28eb8d6987be7e983f4c35379718c31dc3cf0e43aa1de4c9ed7ec40841";
        };
      njpwerner.autodocstring = extensionFromVscodeMarketplace {
        name = "autodocstring";
        publisher = "njpwerner";
        version = "0.5.4";
        sha256 =
          "49470b41a1248345b01544616a44e5ac0fdc1101d2077da913e04f49dfcf5328";
      };
      dongli.python-preview = extensionFromVscodeMarketplace {
        name = "python-preview";
        publisher = "dongli";
        version = "0.0.4";
        sha256 =
          "e777021aed2cfa04b6eaab2e190b3f1dda56913ed710747a0d0f4e5b36cae023";
      };
      ms-toolsai.jupyter = extensionFromVscodeMarketplace {
        name = "jupyter";
        publisher = "ms-toolsai";
        version = "2021.5.697286501";
        sha256 =
          "b0f4658860bf41fe568a29b35171d5ffac9a1118803bbc251f63897b44e9b013";
      };
      formulahendry.auto-close-tag = extensionFromVscodeMarketplace {
        name = "auto-close-tag";
        publisher = "formulahendry";
        version = "0.5.10";
        sha256 =
          "7b9185bb3dd3d86378c11f5db4ab217455b3fb7417dba28d855d5887bc921dc8";
      };
      auchenberg.vscode-browser-preview = extensionFromVscodeMarketplace {
        name = "vscode-browser-preview";
        publisher = "auchenberg";
        version = "0.7.0";
        sha256 =
          "5568ec971d4c368337cf9f2c6073aabbcd8cd5c77845d361026daffda278cf1d";
      };
      ritwickdey.LiveServer = extensionFromVscodeMarketplace {
        name = "LiveServer";
        publisher = "ritwickdey";
        version = "5.6.1";
        sha256 =
          "40f31932db5857e7507d64e7880ee7928ee45ee92a53d83a5a3e580d87cbea1c";
      };
      xabikos.JavaScriptSnippets = extensionFromVscodeMarketplace {
        name = "JavaScriptSnippets";
        publisher = "xabikos";
        version = "1.8.0";
        sha256 =
          "86de969b55fbce27a7f9f8ccbfceb8a8ff8ecf833a5fa7f64578eb4e1511afa7";
      };
      WallabyJs.quokka-vscode = extensionFromVscodeMarketplace {
        name = "quokka-vscode";
        publisher = "WallabyJs";
        version = "1.0.353";
        sha256 =
          "e86f0294630647b6640cc76b2f92404e06abf78841c9a2701167bf9ce1f91d70";
      };
      ritwickdey.live-sass = extensionFromVscodeMarketplace {
        name = "live-sass";
        publisher = "ritwickdey";
        version = "3.0.0";
        sha256 =
          "8220bd676520235c06343d0ba68e2bd17f2848a76aed2b74487a9c6ca2fbbb42";
      };
      dsznajder.es7-react-js-snippets = extensionFromVscodeMarketplace {
        name = "es7-react-js-snippets";
        publisher = "dsznajder";
        version = "3.1.1";
        sha256 =
          "97ff8a44666d4144faa85ff801bf4da156072dae1e04faf5295feb749d2f45bb";
      };
      denoland.vscode-deno = extensionFromVscodeMarketplace {
        name = "vscode-deno";
        publisher = "denoland";
        version = "3.2.0";
        sha256 =
          "ae7badebd86b70ceccfd41eb22f60bc919f3c923f978ce7a497316e5e9aa1502";
      };
      betterthantomorrow.calva = extensionFromVscodeMarketplace {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.182";
        sha256 =
          "836507f06071355882bd3070eea0ff8b9581282ae5ba23fb88f6935eaf78196a";
      };
      ailisp.commonlisp-vscode = extensionFromVscodeMarketplace {
        name = "commonlisp-vscode";
        publisher = "ailisp";
        version = "0.3.2";
        sha256 =
          "09854965e64f6eee7565213629dcb8f1a5f9f008397922a6afa994285dc80915";
      };
      ailisp.strict-paredit = extensionFromVscodeMarketplace {
        name = "strict-paredit";
        publisher = "ailisp";
        version = "0.3.1";
        sha256 =
          "55cd7ec117a364b10a8c5c7de24c4c65a3c5f638216bbedc8ed7d0f3ff1d35cb";
      };
      scalameta.metals = extensionFromVscodeMarketplace {
        name = "metals";
        publisher = "scalameta";
        version = "1.10.0";
        sha256 =
          "043aabbd3f6ec01af55748fd5fd3a080ee6a13ba50f78bfa9027f4812fc1592a";
      };
      rogalmic.bash-debug = extensionFromVscodeMarketplace {
        name = "bash-debug";
        publisher = "rogalmic";
        version = "0.3.9";
        sha256 =
          "7fc154642bf3fcfa27a903fd44235bc902d93e737939c7b411ece6fe10f5f458";
      };
      Remisa.shellman = extensionFromVscodeMarketplace {
        name = "shellman";
        publisher = "Remisa";
        version = "5.4.0";
        sha256 =
          "1cf850e6f1a27db99ff2538e90f68ad7ebaede479f9cbfa8ee570481deae210b";
      };
      ccls-project.ccls = extensionFromVscodeMarketplace {
        name = "ccls";
        publisher = "ccls-project";
        version = "0.1.29";
        sha256 =
          "46331804b81b8be9603ea6aa37bca1f10f33afd7aebd0f982c4a10695dd10ce0";
      };
      stylelint.vscode-stylelint = extensionFromVscodeMarketplace {
        name = "vscode-stylelint";
        publisher = "stylelint";
        version = "0.86.0";
        sha256 =
          "1d8c39afec4e55ee5763199b579d95b625310a9f5a91fd370efba76149cd9b1b";
      };
      sumneko.lua = extensionFromVscodeMarketplace {
        name = "lua";
        publisher = "sumneko";
        version = "2.3.1";
        sha256 = "1jj0k29p4f9hsqprn18nrd2qz5kqw054rsfkgpp5aglhyiv9m6di";
      };
      christian-kohler.npm-intellisense = extensionFromVscodeMarketplace {
        name = "npm-intellisense";
        publisher = "christian-kohler";
        version = "1.3.1";
        sha256 =
          "e4ef4cce1097fce8abe69819c2faac7ae5019822657250cdbef715be55ec7292";
      };
      DominicVonk.parameter-hints = extensionFromVscodeMarketplace {
        name = "parameter-hints";
        publisher = "DominicVonk";
        version = "0.2.7";
        sha256 =
          "462e066307eb99e15c5930fa1e2b19719f7dc06fea7c5787d88ca45a2546b543";
      };
      HookyQR.beautify = extensionFromVscodeMarketplace {
        name = "beautify";
        publisher = "HookyQR";
        version = "1.5.0";
        sha256 =
          "b1480742dbc8369aa10f348d7d27c589e6d9bd7d00e62e5255903fdeb67213b0";
      };
      yatki.vscode-surround = extensionFromVscodeMarketplace {
        name = "vscode-surround";
        publisher = "yatki";
        version = "1.0.2";
        sha256 =
          "55563a2dbd4186a3c40e37b068de5452ee51400beca8df466e414da638f91bcc";
      };
      steoates.autoimport = extensionFromVscodeMarketplace {
        name = "autoimport";
        publisher = "steoates";
        version = "1.5.3";
        sha256 =
          "d18542db46289d9b468f1b95e55775ca8aebc862af4281fb9ae5c03b830ba1f6";
      };
      foxundermoon.shell-format = extensionFromVscodeMarketplace {
        name = "shell-format";
        publisher = "foxundermoon";
        version = "7.0.1";
        sha256 =
          "04b1d01df971ee66ac6600053bdc7d85f5f563be529a967a346d94b24e65bc53";
      };
      vincaslt.highlight-matching-tag = extensionFromVscodeMarketplace {
        name = "highlight-matching-tag";
        publisher = "vincaslt";
        version = "0.10.0";
        sha256 =
          "89a8c637b90386369e5a9988be5fbc0a69ce6f0cd5c6735c04222646c7e78baa";
      };
      cssho.vscode-svgviewer = extensionFromVscodeMarketplace {
        name = "vscode-svgviewer";
        publisher = "cssho";
        version = "2.0.0";
        sha256 =
          "df5cb12d77cf6223e5b061a6f360d3fdf26f7c49e7ffba18bd87bdb123a65c1b";
      };
      stkb.rewrap = extensionFromVscodeMarketplace {
        name = "rewrap";
        publisher = "stkb";
        version = "1.14.0";
        sha256 = "0phffzqv1nmwsgcx6abgzbzw95zc0zlnhsjv2grs5mcsgrghl759";
      };
      zxh404.vscode-proto3 = extensionFromVscodeMarketplace {
        name = "vscode-proto3";
        publisher = "zxh404";
        version = "0.5.3";
        sha256 = "1piih7q2fp81hh356h10xi0v0xvicc9698yp9hj7c08xws3s4i51";
      };
      skellock.just = extensionFromVscodeMarketplace {
        name = "just";
        publisher = "skellock";
        version = "2.0.0";
        sha256 = "1ph869zl757a11f8iq643f79h8gry7650a9i03mlxyxlqmspzshl";
      };
      dunstontc.viml = extensionFromVscodeMarketplace {
        name = "viml";
        publisher = "dunstontc";
        version = "0.1.7";
        sha256 = "0r2dpd07lj8icpbl1nvgk08y6s73bzwv6njpj7m4fcapwjjvhb7l";
      };
      julialang.language-julia = extensionFromVscodeMarketplace {
        name = "language-julia";
        publisher = "julialang";
        version = "1.2.8";
        sha256 = "1yh3mzar0v8aai52smw3wasc8cysdlqhnkhvydhpx039xl0i3pdc";
      };
    };
}
