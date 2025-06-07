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
            # Intellij CE IDE with Scala Plugin
            (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community ["scala"])

            # latest LTS release from Temurin OpenJDK distribution
            pkgs.temurin-bin

            # language server for Scala (if using an editor like VS Code or Zed)
            pkgs.metals
          ];
        };
      }
    );
}
