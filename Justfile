default:
    just --list

update_lock:
    docker volume create nix-store;
    MSYS_NO_PATHCONV=1 docker run --rm \
        -v nix-store:/nix \
        -v "{{justfile_directory()}}:/root/repository" \
        -w "/root/repository" \
        nixos/nix:latest \
        sh -c "nix --extra-experimental-features 'nix-command flakes' flake update"

lint:
    docker volume create nix-store;
    MSYS_NO_PATHCONV=1 docker run --rm \
    -v nix-store:/nix \
    -v "{{justfile_directory()}}:/root/repository" \
    -w "/root/repository" \
    nixos/nix:latest \
    sh -c "nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#nixpkgs-fmt -c nixpkgs-fmt --check ."

clean:
    docker volume rm nix-store;
