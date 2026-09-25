{
  description = "Azure's Portable Shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.gradlever.url = "github:syntacticallyazure/gradlever";

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
            gradlever.packages.${system}.default
          ];

          config = {
            # oh-my-posh.tokyo_nights = ./oh-my-posh/tokyo_nights.omp.json;
            # oh-my-posh.catppuccin_mocha = ./oh-my-posh/catppuccin_mocha.omp.json;
            oh-my-posh.catppuccin_frappe = ./config/oh-my-posh/catppuccin_frappe.omp.json;
            # oh-my-posh.catppuccin_latte = ./oh-my-posh/catppuccin_latte.omp.json;
          };

          fastfetchPackages = with pkgs; [
            just
            python3
            fastfetch
            sherlock
          ];

          fastfetchExceptions = {
            python3 = "python";
          };

          fastfetchModules = map (
            package:
            let
              name = package.pname or package.name;
            in
            {
              type = "custom";
              key = fastfetchExceptions.${name} or name;
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
              alias tor='tor --HTTPTunnelPort 8118'

              alias mv='mv -v';
              alias cp='cp -v';
              alias rm='rm -v';

              eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init bash --config ${config.oh-my-posh.catppuccin_frappe})"
            '';
          };
        }
      );
    };
}