{ config, pkgs, lib, ... }: with lib; {
	nixpkgs.config.allowUnfree = true;

	users.users.hcentner = { home = "/Users/hcentner"; isNormalUser = true; createHome = true; shell = pkgs.zsh; openssh.authorizedKeys.keys = [ 
		"/home/hcentner/id_ed25519.pub" ]; group = "wheel";

	};
	programs.zsh.enable = true;
        nix.settings.experimental-features = [ "flakes" "nix-command" ];
        boot.loader.systemd-boot.enable = true; boot.loader.efi.canTouchEfiVariables = true;

        system.stateVersion = "25.05";
        services.openssh.enable = true;
	documentation.enable = true; documentation.nixos.enable = true;
}
