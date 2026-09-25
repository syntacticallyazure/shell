default:
    just --list

lint:
    # TODO

update_lock:
    docker volume create nix-store;
    MSYS_NO_PATHCONV=1 docker run --rm \
        -v nix-store:/nix \
        -v "{{justfile_directory()}}:/root/repository" \
        -w "/root/repository" \
        nixos/nix:latest \
        sh -c "nix --extra-experimental-features 'nix-command flakes' flake update"

clean:
    docker volume rm nix-store;
