default:
    just --list


update_lock:
    # MSYS_NO_PATHCONV=1 docker run --rm \
    #     -v "{{justfile_directory()}}:/repo" \
    #     -w /repo \
    #     nixos/nix:latest \
    #     sh -c "nix --extra-experimental-features 'nix-command flakes' flake update" \
    # && git add flake.lock \
    # && git commit -m "chore: updated flake lockfile" \
    # && git push

    docker volume create nix-store;
    MSYS_NO_PATHCONV=1 docker run --rm \
        -v nix-store:/nix \
        -v "{{justfile_directory()}}:/root/repository" \
        -w "/root/repository" \
        nixos/nix:latest \
        sh -c "nix --extra-experimental-features 'nix-command flakes' flake update"