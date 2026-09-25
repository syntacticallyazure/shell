default:
    just --list

update:
    #!/usr/bin/env sh
    if [ "{{os()}}" = "windows" ]; then
        docker volume create nix-store

        MSYS_NO_PATHCONV=1 docker run --rm \
            -v nix-store:/nix \
            -v "{{justfile_directory()}}:/root/repository" \
            -w /root/repository \
            nixos/nix:latest \
            sh -c "nix --extra-experimental-features 'nix-command flakes' flake update"
    else
        nix flake update
    fi

lint:
    #!/usr/bin/env sh
    if [ "{{os()}}" = "windows" ]; then
        docker volume create nix-store

        MSYS_NO_PATHCONV=1 docker run --rm \
            -v nix-store:/nix \
            -v "{{justfile_directory()}}:/root/repository" \
            -w /root/repository \
            nixos/nix:latest \
            sh -c "nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#nixfmt nixpkgs#statix -c sh -c 'nixfmt --check . && statix check .'"
    else
        nix shell nixpkgs#nixfmt nixpkgs#statix \
            -c sh -c 'nixfmt --check . && statix check .'
    fi

clean:
    #!/usr/bin/env sh
    if [ "{{os()}}" = "windows" ]; then
        docker volume rm nix-store
    fi