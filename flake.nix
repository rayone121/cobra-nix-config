{
  description = "Cobra NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, plasma-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.cobra = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          disko.nixosModules.disko
          ./hosts/cobra/disk.nix
          ./hosts/cobra/configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.raymond = import ./home/default.nix;
            home-manager.sharedModules = [
              plasma-manager.homeModules.plasma-manager
            ];
          }
        ];
      };

      apps.${system}.install = let
        installer = pkgs.writeShellScriptBin "cobra-install" (builtins.readFile ./install.sh);
      in {
        type = "app";
        program = "${installer}/bin/cobra-install";
      };
    };
}
