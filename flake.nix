{
    description = "My personal blog";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        pkgsFor = nixpkgs.legacyPackages;
    in
    {
        # Configs the recipe for building the "package" which in case is my personal blog
        packages.${system} = { 
            default = pkgsFor.${system}.callPackage nix/default.nix { };
        };
        
        # Configs the development shell
        devShells.${system} = {
            default = pkgsFor.${system}.callPackage nix/shell.nix { };
        };
    };
}

