{
  description = "Typsite Env";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    typsite.url = "github:Glomzzz/typsite";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    typsite,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages.default = pkgs.mkShell {
          packages = [
            pkgs.typst
            typsite.packages.${system}.default
          ];
        };
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.typst
            typsite.packages.${system}.default
          ];
        };
      }
    );
}
