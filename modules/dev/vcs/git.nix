{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.vcs.git;
  configDir = config.dotfiles.configDir;
in {
  options.modules.dev.vcs.git = {
    enable = mkBoolOpt false;
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [
        eamodio.gitlens
        rubbersheep.gi
        vsls-contrib.gistfs
        donjayamanne.githistory
        felipecaputo.git-project-manager
        qezhu.gitlink
        lamartire.git-indicators
        erichbehrens.pull-request-monitor
      ]);
    };
    zsh_plugin_text = mkOption {
      type = types.lines;
      description = "How to source necessary zsh plugins";
      default = ''
        # Git Flow Completions
        path+="${inputs.zsh-completion-git-flow}"
        fpath+="${inputs.zsh-completion-git-flow}"
        source ${inputs.zsh-completion-git-flow}/git-flow-completion.plugin.zsh

        # Forgit - A utility tool powered by fzf for using git interactively. 
        path+="${inputs.zsh-tool-forgit}"
        fpath+="${inputs.zsh-tool-forgit}"
        source ${inputs.zsh-tool-forgit}/forgit.plugin.zsh

        alias g='git'

        alias ga='git add'
        alias gaa='git add --all'
        alias gapa='git add --patch'
        alias gau='git add --update'
        alias gav='git add --verbose'
        alias gap='git apply'

        alias gb='git branch'
        alias gba='git branch -a'
        alias gbd='git branch -d'
        alias gbD='git branch -D'
        alias gbl='git blame -b -w'
        alias gc='git commit -v'
        alias gc!='git commit -v --amend'
        alias gcam='git commit -a -m'
        alias gcsm='git commit -s -m'
        alias gcb='git checkout -b'
        alias gcf='git config --list'
        alias gcl='git clone --recurse-submodules'
        alias gcm='git checkout main'
        alias gcd='git checkout develop'
        alias gcm='git checkout master'
        alias gcd='git checkout develop'

        alias gf='git fetch'
        alias gfa='git fetch --all --prune'
        alias gfo='git fetch origin'

        alias gfg='git ls-files | grep'

        alias gl='git pull'
        alias glg='git log --stat'
        alias glgp='git log --stat -p'
        alias glgg='git log --graph'
        alias glgga='git log --graph --decorate --all'
        alias glgm='git log --graph --max-count=10'
        alias glo='git log --oneline --decorate'

        alias gm='git merge'
        alias gmom='git merge origin/master'
        alias gmt='git mergetool --no-prompt'
        alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
        alias gmum='git merge upstream/master'
        alias gma='git merge --abort'

        alias gp='git push'
        alias gr='git remote'
        alias gra='git remote add'
        alias grb='git rebase'
        alias grba='git rebase --abort'
        alias grbc='git rebase --continue'
        alias grbd='git rebase develop'
        alias gru='git reset --'
        alias grup='git remote update'
        alias grv='git remote -v'
        alias gsb='git status -sb'

        alias gts='git tag -s'
        alias gtv='git tag | sort -V'
              '';
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.delta
      gitAndTools.lazygit
      gitAndTools.gitui
      gitAndTools.gitflow
    ];

    home-manager.users.${config.user.name}.programs.git = {
      enable = true;
      userName = "Th3Whit3Wolf";
      userEmail = "the.white.wolf.is.1337@gmail.com";
      lfs.enable = true;
      signing = {
        key = "";
        signByDefault = false;
      };
      ignores = [ "*.swp" ".direnv" "Session.vim" ];
      extraConfig = {
        core = {
          quotepath = "off";
          editor = "${config.modules.editors.default}";
          excludesfile = "~/.config/git/ignore";
          whitespace = "trailing-space,space-before-tab";
        };
        color = {
          ui = "auto";
          diff = "auto";
          status = "auto";
        };
        commit.verbose = true;
        credentil.helper = "${pkgs.git}/git-credential-libsecret";
        pull.ff = "only";
        fetch = {
          recurseSubmodules = "on-demand";
          prune = true;
        };
        init.defaultBranch = "main";
        rebase = {
          autosquash = true;
          autostash = true;
        };
        recieve.fsckobjects = true;
        status.submoduleSummary = true;
        tag.gpgSign = true;
        transfer.fsckobjects = true;
        trim.bases = "master,gh-pages";
      };
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          side-by-side = true;
          features = "decorations";
          theme = "OneHalfDark";
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-style = "bold yellow ul";
            file-decoration-style = "none";
          };
        };
      };
      aliases = {
        a = "add";
        ap = "add -p";
        b = "branch";
        bm = "branch --merged";
        bnm = "branch --no-merged";
        c = "clone";
        ca = "commit --amend";
        cane = "commit --amend --no-edit";
        cf = "commit --fixup";
        cm = "commit --message";
        co = "checkout";
        cob = "checkout -b";
        com = "checkout master";
        cp = "cherry-pick";
        d = "diff --patience";
        dc = "diff --cached";
        dom = "diff origin/master";
        fo = "fetch origin";
        g = "grep --line-number";
        mbhom = "merge-base HEAD origin/master";
        mff = "merge --ff-only";
        ol = "log --pretty=oneline";
        l =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        p = "push";
        pf = "push --force-with-release";
        prb = "pull --rebase";
        r = "restore";
        ra = "rebase --abort";
        rc = "rebase --continue";
        ri = "rebase --interactive";
        rl = "reflog";
        riom = "rebase --interactive origin/master";
        rpo = "remote prune origin";
        s = "status -sb";
        ss = "commit --message snapshot --no-gpg-sign";
        su = "submodule update";
        tags = "tag -l";
        wd = "diff --patience --word-diff";

        # I like hg incoming/hg outgoing; they make perfect sense to me
        # NB: starting with git 1.7.0 I can use @{u} to refer to origin
        # see also http://stackoverflow.com/questions/231211/using-git-how-do-i-find-modified-files-between-local-and-remote/6389348#6389348
        # NB: starting with git 2.5.0 I can use @{push} to support triangular workflows (thanks Seveas from #git for the tip!)
        outgoing = "log --oneline @{u}..";
        incoming = "!git fetch && git log --oneline ..@{u}";

        ignore = ''
          "!f() { for arg in "$@"; do echo "$arg" >> .gitignore; done; git add .gitignore 2>/dev/null; }; f"'';
        exclude = ''
          "!f() { for arg in "$@"; do echo "$arg" >> "$(git rev-parse --git-dir)/info/exclude"; done; }; f"'';
        # list all roots (commits without a parent)
        roots = "log --all --oneline --decorate --max-parents=0";
        ignored = "!git status --ignored | tail -n +4";
        unstage = "reset HEAD --";
        uncommit = "reset HEAD^";
        recommit = "commit --amend --no-edit";

        # git undo, for unding an accidental git amend/reword/commit; use with care
        undo = "reset HEAD@{1}";

        # git update pulls latest stuff from upstream and cleans merged branches
        up = "!git update";
        update =
          "!git checkout-if-not-already-on $(git main-branch) && git pull --ff-only && git clean-merged-branches";

        # testing merges (I rarely use these; I don't even remember how to use them!)
        preview-merge = ''
          "!f() { b=origin/$1; git log --oneline master..$b && git merge --no-commit --no-ff $b; }; f"'';
        branch-changes = ''
          "!f() { b=origin/$1; m=$(git log --pretty=%H -1 --first-parent --merges --grep="^Merge branch '$1'" master); shift; git diff $m^...$m^2 "$@"; }; f"'';

        # print the name of the current branch
        branch-name = "symbolic-ref --short HEAD";

        # let's do code review!
        review = ''
          "!vim +'set ft=diff bt=nofile|exe "0r !git branch-diff -p --stat"|1|exe "silent file" escape(printf("git diff of the %s branch", systemlist("git branch-name")[0]), " |\\")'"'';

        # show current commit SHA; try also git sha --short and git sha [--short] somebranch
        sha = ''
          "!f() { rev=HEAD; for a; do case "$a" in -*) ;; *) rev=;; esac; done; git rev-parse "$@" $rev; }; f"'';

        # print the remote URL
        # NB: I don't want to use git remote get-url origin because I don't want insteadOf expansion that
        # converts password-protected https:// links I can click on to ssh:// links that I can't.
        url = "config remote.origin.url";

        # open the repository in a browser
        open-url = "!xdg-open $(git url)";

        # show tag name of the last release tag on current branch
        last-release = "describe --tags --abbrev=0 --exclude=last*";
        me = "log --author='Th3Whit3Wolf'";
      };
    };
  };
}
