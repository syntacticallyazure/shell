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

        shellHooks = {
          fastfetch = ''
            alias fastfetch="${pkgs.fastfetch}/bin/fastfetch --config ${config.fastfetch.jsonc}";
          '';
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
            ];
          };
        }
      );
    };
}