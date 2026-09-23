{
  description = "Azure's Portable Shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
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
            xh
            dust
            hyperfine
            delta
            ripgrep
            ripgrep-all
            aria2
            nmap
            tor
            sherlock
          ];

          fastfetchPackages = with pkgs; [
            git
            just
            nano
            fastfetch
            onefetch
            lnav
            htop
            wget
            curl
            python3
            uv
            fd
            bat
            eza
            xh
            dust
            hyperfine
            delta
            ripgrep
            ripgrep-all
            aria2
            nmap
            tor
            sherlock
          ];

          fastfetchModules = map (
            package: {
              type = "custom";
              key = package.pname or package.name;
              format = package.version or "unknown";
            }
          ) fastfetchPackages;

          fastfetchConfig = pkgs.writeText "fastfetch.json" (
            builtins.toJSON {
              "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

              logo = {
                type = "none";
              };

              modules = fastfetchModules;
            }
          );
        in
        {
          default = pkgs.mkShell {
            inherit packages;

            shellHook = ''
              alias cat='bat'
              alias ncdu='dust'
              alias du='dust'
              alias ls='eza'
              alias ripgrep='rga'
              alias of='onefetch'
              alias fastfetch='${pkgs.fastfetch}/bin/fastfetch --config ${fastfetchConfig}'
              alias ff='fastfetch'
              alias neofetch='fastfetch'
              alias aria2c='aria2c --seed-time=0'
              alias where='which'
              alias scoop='echo "Hey! You are on Unix, not Windows!"'
            '';
          };
        }
      );
    };
}