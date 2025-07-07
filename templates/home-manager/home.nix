# could add additional overrides here
{ config, pkgs, ... }: 
{
  home = {
    username = "harrisoncentner";
    # homeDirectory = "/home/harrisoncentner";

    # Set Git commit hash for darwin-version.
    # home.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    sessionPath = [
      "/home/harrisoncentner/nixconfig"
    ];
    sessionVariables = {
      EDITOR = "vim";
      #shellAliases = {
      # rebuild-vm = "sudo nixos-rebuild switch --flake #hcentner-utm"; rebuild-desktop = "sudo nixos-rebuild switch --flake #hcentner-desktop";
      # };
    };

    stateVersion = "24.11";
  };
  home.packages = with pkgs; [
    duf # disk usage/free utility
    fd # find alternative
    gh # github clie tool
    jq # JSON processor
    nixpkgs-fmt # nix formatter
    cabal2nix # generate nix derivations from cabal files
    sd # sed alternative
    sqlite # transactional SQL database engine
    unzip # extraction tool for archives compressed
    usbutils # tools for USB devices
    direnv # manage environment variables based on directory
    nix-direnv # persistent use_nix implementation for direnv
    ripgrep # parallel grep written in rust
    tree # graphical file system display
    nixd # nix language server
    file # determine file types
    htop # view compute statistics
    lsof # view port information
    lazygit # easy UI for git
    bc # gnu basic calculator
    typst # typesetting language
    nix-output-monitor # nom for nix
    dhall # configuration language
    nurl # generate nix fetcher calls from repo URLS
  ];
  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "history" "git" ];
        theme = "eastwood";
      };
    };
    bash = {
      enable = true;
      shellAliases = { };
      historySize = 1000000;
      historyControl = [ "ignoredups" "ignorespace" ];
      initExtra = ''
        set -o vi
        '';
    };
    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      git = true;
      icons = "never";
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    # terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };
    tmux = {
      enable = true;
      mouse = true;
      terminal = "xterm-256color";
      keyMode = "vi";
      baseIndex = 1;
      aggressiveResize = true;
      historyLimit = 250000;
      prefix = "C-space";
      sensibleOnTop = false;
      extraConfig = '' #
        bind -r h select-pane -L
        bind -r h select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R
        set -g default-command /bin/zsh
        '';
    };
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
    };
    git = {
      lfs.enable = true;
      userName = "hcentner";
      userEmail = "harrison.centner@gmail.com";
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          dark = true;
          side-by-side = false;
          line-numbers = true;
          features = "zebra-dark";
          # this isn't in the RTP for some reason so we clone it from
          # https://github.com/dandavison/delta/blob/main/themes.gitconfig
          zebra-dark = {
            minus-style = "syntax \"#330f0f\"";
            minus-emph-style = "syntax \"#4f1917\"";
            plus-style = "syntax \"#0e2f19\"";
            plus-emph-style = "syntax \"#174525\"";
            map-styles = ''
              bold purple => syntax "#330f29",
                   bold blue => syntax "#271344",
                   bold cyan => syntax "#0d3531",
                   bold yellow => syntax "#222f14"
                     '';
            zero-style = "syntax";
            whitespace-error-style = "#aaaaaa";
          };
        };
      };
      extraConfig = {
          user.signingKey = "~/.ssh/id_ed25519";
          core.editor = "vim";
          gpg.format = "ssh";
          commit.gpgsign = true;
          tag.gpgsign = true;
          diff.colorMoved = "default";
          merge.conflictstyle = "diff3";
          init.defaultBranch = "master";
          rerere.enabled = true;
      };
      ignores = [ "target" "result" "/.vscode" ".direnv" ".envrc" ".nixcpy" ];
    };
  };
}
