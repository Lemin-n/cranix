{
  description = "Cranix";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: {
        lib = {
          craneOverride = import ./cranix {
            inherit flake-utils system;
            pkgs = nixpkgs.legacyPackages.${system};
          };
        };
      }
    );
}
