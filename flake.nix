{
    description = "My personal blog";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    };

    outputs = { self, nixpkgs }:
    let
        #system = "x86_64-linux";
        forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
        pkgsFor = nixpkgs.legacyPackages;
    in
    {
       
        packages = forAllSystems (system: {
        default = pkgsFor.${system}.callPackage nix/default.nix { };
       # vm = vmFor.${system}.config.system.build.vm;
      });
        
        
        devShells = forAllSystems (system: {
        default = pkgsFor.${system}.callPackage nix/shell.nix { };
      });
    };
}

