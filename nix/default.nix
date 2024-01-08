{ pkgs, fetchFromGitHub, ...}:

let
    # Flake does not support submodule (https://github.com/NixOS/nix/issues/4423)
    # Fetch manually for now
    blowfish = fetchFromGitHub {
    owner = "nunocoracao";
    repo = "blowfish";
    rev = "v2.49.1";
    sha256 = "sha256-SHBGMV+IUBLYsYklt8NHGpWxzRHmwbK//o6pwFmmlbE="; # Still have to discover the hash 
  };
  repo_name = "personal_blog"; # Need for GitHub Pages correct css indexing (not /css and yes /repo_name/css)
in pkgs.stdenv.mkDerivation {
    name = "${repo_name}";
    src = ./../.;
    nativeBuildInputs = with pkgs; [ hugo git ]; 
    buildPhase = "
        rm -df themes/blowfish
        ln ${blowfish} -sfT themes/blowfish
        hugo --gc --minify --baseURL /${repo_name}
        ";
    
    installPhase = "cp -r public $out";
}
