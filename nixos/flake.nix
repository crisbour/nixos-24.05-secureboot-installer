{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows="nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, lanzaboote }@inputs:
    let
      inherit (self) outputs;

      # TODO: Is this necessary? Perhaps for accessing home-manager.lib.homeManagerConfiguration easier
      lib = nixpkgs.lib;

      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      });
    in
    {
      inherit lib;
      #packages  = forEachSystem (pkgs: import ./pkgs { inherit pkgs inputs; });

      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        modules = [./configuration.nix];
        specialArgs = { inherit inputs; };
      };
    };
}
