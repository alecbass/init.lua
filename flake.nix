{
  description = "Nix flake for editing this repository.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs }: let
    allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
    ];

    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
    });
  in {
    devShell = forAllSystems({ pkgs, system }:
        pkgs.mkShell {
            buildInputs = with pkgs; [
                neovim # Should use the latest version
                lua-language-server # For editing files
            ];
        }
    );
  };
}
