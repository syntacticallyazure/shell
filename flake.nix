{
  description = "Azure's Portable Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

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

          wordlist_subdirectories = pkgs.fetchFromGitHub {
            owner = "aels";
            repo = "subdirectories-discover";
            rev = "main";
            hash = "sha256-4soBZLuIUXf9tBSzvgmeA5GFI9unfql55ZAmSIzemL0=";
          };

          feroxbuster = pkgs.symlinkJoin {
            name = "feroxbuster";
            paths = [ pkgs.feroxbuster ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/feroxbuster --add-flags '--wordlist ${wordlist_subdirectories}/directory-list-2.3-medium.txt'";
          };

          aria2 = pkgs.symlinkJoin {
            name = "aria2";
            paths = [ pkgs.aria2 ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/aria2c --add-flags '--seed-time=0'";
          };

          tor = pkgs.symlinkJoin {
            name = "tor";
            paths = [ pkgs.tor ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/tor --add-flags '--HTTPTunnelPort 8118'";
          };

          coreutils = pkgs.symlinkJoin {
            name = "coreutils";
            paths = [ pkgs.coreutils ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/mv --add-flags '-v'
              wrapProgram $out/bin/cp --add-flags '-v'
              wrapProgram $out/bin/rm --add-flags '-v'
            '';
          };

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
            feroxbuster
            sherlock
            nikto
            wordlist_subdirectories
            coreutils
          ];

          config = {
            oh-my-posh.catppuccin_frappe = ./config/oh-my-posh/catppuccin_frappe.omp.json;
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
              alias where='which'

              eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init bash --config ${config.oh-my-posh.catppuccin_frappe})"
            '';
          };
        }
      );
    };
}