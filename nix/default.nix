{self, nixpkgs, fetchFromGitHub, ...}:

let
    # Flake does not support submodule (https://github.com/NixOS/nix/issues/4423)
    # Fetch manually for now
    blowfish = fetchFromGitHub {
    owner = "nunocoracao";
    repo = "blowfish";
    rev = "v2.49.1";
    sha256 = ""; # Still have to discover the hash 
  };
in nixpkgs.stdenv.mkDerivation {
    name = "my_personal_blog";
    src = "self";
    
    buildPhase = "
        rm -df themes/blowfish
        ln ${blowfish} -sfT themes/blowfish
    ";
    
    installPhase = "cp -r public $out";
}
