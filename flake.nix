{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        # The packages available in the development shell created by running `nix develop`
        devShell = pkgs.mkShell {
          packages = [
            pkgs.temurin-bin # latest LTS release from Temurin OpenJDK distribution
            pkgs.metals # language server for Scala
          ];
        };
      }
    );
}
