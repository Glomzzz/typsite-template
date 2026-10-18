{
  description = "Typsite Env";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Keep the executable aligned with the bundled 0.1.8 resources.
    typsite.url = "github:Glomzzz/typsite/ad74311de77921211e62fbc9cd7f0bb0f42a76f7";
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
        packages.default = typsite.packages.${system}.default;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.typst
            typsite.packages.${system}.default
          ];
        };
      }
    );
}
