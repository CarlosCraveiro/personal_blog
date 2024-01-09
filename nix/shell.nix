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
    repo_name="personal_blog";
    
    colors = ''
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[0;33m'
        BLUE='\033[0;34m'
        PURPLE='\033[0;35m'
        CYAN='\033[0;36m'  
        NC='\033[0m'
    '';
    blog_help = pkgs.writeShellScriptBin "blog_help" ''
     ${colors}
        echo -e $PURPLE"Ações possíveis:"$NC
        echo -e "1. Subir e abrir instancia local:  "$GREEN"blog_develop"$NC
        echo -e "2. Abrir a instancia local:        "$GREEN"blog_open"$NC
        echo -e "3. Matar a instancia local:        "$GREEN"blog_kill"$NC
        echo -e "4. Cria novo post:                 "$GREEN"blog_new_post"$NC $CYAN"publication"$NC
        echo -e ""
        echo -e "Outros comandos disponíveis:"
        echo -e "- Subir manualmente com o hugo:    "$YELLOW"hugo server -D"$NC
        echo -e "- Buildar em modo de produção:     "$BLUE"nix build"$NC
        echo -e ""
        echo -e "- Ver essa mensagem:               "$PURPLE"blog_help"$NC
        echo -e ""
    '';   

    blog_develop = pkgs.writeShellScriptBin "blog_develop" '' 
        hugo server -D &
        xdg-open http://localhost:1313/${repo_name}/
    '';
    
    blog_new_post = pkgs.writeShellScriptBin "blog_new_post" '' 
        hugo new posts/''${1}
    '';


    blog_open = pkgs.writeShellScriptBin "blog_open" ''
        xdg-open http://localhost:1313/${repo_name}/
    '';

    blog_kill = pkgs.writeShellScriptBin "blog_kill" '' 
        pkill hugo
    '';
 
in
(pkgs.callPackage ./default.nix { }).overrideAttrs (oa: {
    nativeBuildInputs = with pkgs; [
        # My development shell
        zsh
        # Needed for to open hugo automatically
        xdg-utils
        # The lightest browser I could think of. In the case of a person without a web browser installed
        chromium
        # Scripts
        blog_develop
        blog_kill
        blog_help
        blog_open
        blog_new_post

    ] ++ (oa.nativeBuildInputs or []);

    shellHook = ''
        rm -df themes/blowfish
        ln ${blowfish} -sfT themes/blowfish

        zsh
    '';
})
