{
  description = "Azure's Portable Shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      devShells = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

        config = {
          fastfetch.jsonc = ./config/fastfetch.jsonc;
        };

        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              git
              bash
              openssh
              just
              nano
              man
              fastfetch
              onefetch
              lnav
              htop
              ncdu
              wget
              curl
              p7zip
              util-linux
              zip
              unzip
              python3
              uv
              fd
              bat
              eza
              zoxide
              xh
              dust
              hyperfine
              delta
              ripgrep
              ripgrep-all
              aria2
            ];

            shellHook = ''
              alias cat='bat'
              alias ncdu='dust'
              alias du='dust'
              alias queue='pueue'
              alias ls='eza'
              alias ripgrep='rga'
              alias of='onefetch'
              alias fastfetch='${pkgs.fastfetch}/bin/fastfetch --config ${config.fastfetch.jsonc}'
              alias ff='fastfetch'
              alias neofetch='fastfetch'
              alias aria2c='aria2c --seed-time=0'
              eval "$(zoxide init --cmd cd bash)"
            '';
          };
        }
      );
    };
}