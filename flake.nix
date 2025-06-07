{
  description = "Typsite Env";
  inputs = {
    typst.url = "github:typst/typst/";
    typsite.url = "github:Glomzzz/typsite";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    typst,
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
        devShells.default = pkgs.mkShell {
          packages = [
            typst.packages.${system}.default
            typsite.packages.${system}.default
          ];
        };
      }
    );
}
