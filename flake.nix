{
  description = "My hybrid nixos / nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nix-darwin, nixpkgs, home-manager, ... }:
    let
    configuration = { pkgs, ... }: {
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      # This will allow you to use nix-darwin with Determinate. Some nix-darwin functionality that relies on managing the Nix installation, like the `nix.*` options to adjust Nix settings or configure a Linux builder, will be unavailable.
      nix.enable = false;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
 };
defaultModules = [
		home-manager.nixosModules.home-manager {
			_module.args = {inherit inputs;};
			home-manager = {
				useGlobalPkgs = true;
				useUserPackages = true;
				extraSpecialArgs = {inherit inputs;};
				users.hcentner = import ./templates/utm/home.nix;
			};
			imports = [ ./templates/utm/hardware-configuration.nix ];
}
];
 in
 {
# Build darwin flake using:
# $ darwin-rebuild build --flake .#Harrisons-MacBook-Pro-7
    formatter = nixpkgs.nixpkgs-fmt;
    darwinConfigurations."Harrisons-MacBook-Pro-7" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        ./modules/system.nix
        
        home-manager.darwinModules.home-manager {
          home-manager = {
            # include the home-manager module
            users.harrisoncentner = import ./templates/home-manager/home.nix;
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          users.users.harrisoncentner.home = "/Users/harrisoncentner";
          nix.settings.trusted-users = ["harrisoncentner"];
        }
      ];

    };
    nixosConfigurations = {
	    hcentner-personal-utm = nixpkgs.lib.nixosSystem {
		    system = "x86_64-linux";
		    modules = [ ./templates/utm/default.nix ] ++ defaultModules;
	    };
    };
 };
}
