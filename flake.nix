{
  description = "My hybrid nixos / nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
    let
    configuration = { pkgs, ... }: {
      home = {
        username = "hcentner";
        homeDirectory = "/home/hcentner";
        sessionPath = [
          "/home/hcentner/nixconfig"
        ];
        sessionVariables = {
          EDITOR = "vim";
          XDG_CACHE_HOME = "$HOME/.cache";
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_DATA_HOME = "$HOME/.local/share";
          XDG_STATE_HOME = "$HOME/.local/state";
          shellAliases = {
# rebuild-vm = "sudo nixos-rebuild switch --flake #hcentner-utm"; rebuild-desktop = "sudo nixos-rebuild switch --flake #hcentner-desktop";
          };
          stateVersion = "21.05";
          packages = with pkgs; [
            duf # disk usage/free utility 
              fd # find alternative 
              gh # github clie tool 
              jq # JSON processor 
              nixpkgs-fmt # nix formatter 
              parted # manage partitions
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
              virtiofsd # utm shared folder 
              typst # typesetting language 
              nix-output-monitor # nom for nix 
              dhall # configuration language
              nurl # generate nix fetcher calls from repo URLS 
              ];
        };
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
          tmux = {
            enable = true; 
            mouse = true;
            terminal = "xterm-256color";
            keyMode = "vi";
            baseIndex = 1;
            aggressiveResize = true;
            historyLimit = 250000;
            prefix = "C-a";
            extraConfig = '' #
              bind -r h select-pane -L
              bind -r h select-pane -D
              bind -r k select-pane -U
              bind -r l select-pane -R
              '';
          };
          git = {
            ignores = [ "target" "result" "/ vscode" "direnv" ".envrc" "nixcpy" ];
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
            direnv = {
              enable = true;
              enableBashIntegration = true; # see note on other shells below
                nix-direnv.enable = true;
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
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "x86_64-darwin";
        };
      };
    };
  in
  {
  # Build darwin flake using:
  # $ darwin-rebuild build --flake .#Harrisons-MacBook-Pro-7
    darwinConfigurations."Harrisons-MacBook-Pro-7" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
