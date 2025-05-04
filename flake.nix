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

  outputs = inputs@{ nix-darwin, nixpkgs, home-manager, ... }:
    let
    configuration = { pkgs, ... }: {
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
 };
 in
 {
# Build darwin flake using:
# $ darwin-rebuild build --flake .#Harrisons-MacBook-Pro-7
    darwinConfigurations."Harrisons-MacBook-Pro-7" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        ./modules/system.nix
        
        home-manager.darwinModules.home-manager {
          home-manager = {
            # include the home-manager module
            users.hcentner = import ./templates/home-manager/home.nix;
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          users.users.hcentner.home = "/Users/harrisoncentner";
          nix.settings.trusted-users = ["harrisoncentner"];
        }
      ];

    };
  };
}
