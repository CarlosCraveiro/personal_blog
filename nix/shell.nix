{ pkgs ? import <nixpkgs> { }, fetchFromGitHub, ... }:

let
    # Flake does not support submodule (https://github.com/NixOS/nix/issues/4423)
    # Fetch manually for now
    blowfish = fetchFromGitHub {
        owner = "nunocoracao";
        repo = "blowfish";
        rev = "v2.49.1";
        sha256 = "sha256-SHBGMV+IUBLYsYklt8NHGpWxzRHmwbK//o6pwFmmlbE="; # Still have to discover the hash 
    };
in
(pkgs.callPackage ./default.nix { }).overrideAttrs (oa: {
    nativeBuildInputs = with pkgs; [
        hugo
    ] ++ (oa.nativeBuildInputs or []);

    shellHook = ''
        rm -df themes/blowfish
        ln ${blowfish} -sfT themes/blowfish
    '';
})
