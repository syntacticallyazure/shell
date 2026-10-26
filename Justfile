default:
    just --list

clean:
    docker volume rm nix-store;
