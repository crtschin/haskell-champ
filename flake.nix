{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "haskell-champ";
        ghcVer = "ghc910";
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskell.packages.${ghcVer};
      in {
        packages.${name} =
          haskellPackages.callCabal2nix name self {};

        packages.default = self.packages.${system}.${name};
        defaultPackage = self.packages.${system}.default;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            haskellPackages.haskell-language-server
            haskellPackages.cabal-install
            haskellPackages.cpphs
            haskellPackages.eventlog2html

            nixfmt-rfc-style
          ];
        };
        devShell = self.devShells.${system}.default;
      });
}
