{
  description = "Lily's Scrumptious NixOs Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";

    nix-colors.url = "github:misterio77/nix-colors";

    musnix.url = "github:musnix/musnix";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [ ./nixos/configuration.nix ];
      };
      live = nixpkgs.lib.nixosSystem {
        system = "x86_x64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          (nixpkgs
            + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ./live/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "lily@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
        }; # Pass flake inputs to our config
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
