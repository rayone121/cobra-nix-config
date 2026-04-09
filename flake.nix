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
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, niri, ... }:
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
              niri.homeModules.niri
            ];
          }
        ];
      };

      # Run: nix --extra-experimental-features "nix-command flakes" run github:rayone121/cobra-nix-config#install
      apps.${system}.install = let
        installer = pkgs.writeShellScriptBin "cobra-install" (builtins.readFile ./install.sh);
      in {
        type = "app";
        program = "${installer}/bin/cobra-install";
      };
    };
}
