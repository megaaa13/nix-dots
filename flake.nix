{
  description = "My NixOS Configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    themecord = {
      url = "github:danihek/themecord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = 
    { self, nixpkgs, home-manager, ... }@inputs: 
    let
      lib = nixpkgs.lib // home-manager.lib;
    in
    {
      inherit lib;

      nixosConfigurations = {
        tower = nixpkgs.lib.nixosSystem rec {
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/hosts/tower
            home-manager.nixosModules.default
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.lanzaboote.nixosModules.lanzaboote
          ];
	      };
        laptop = nixpkgs.lib.nixosSystem rec {
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/hosts/laptop
            home-manager.nixosModules.default
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.lanzaboote.nixosModules.lanzaboote
          ];
	      };
      };
    };
}
