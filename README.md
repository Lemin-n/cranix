# Cranix: A High-Level Crane API Override 🦀 ❄️

Cranix introduces new integrations to the Crane APIs.

## Integrations

- **Mold**: Enable by setting `useMold = true`.
- **Cranelift**: Enable by setting `useCranelift = true`.
- **Workspace Package**: To create your own `Workspace Package` derivation, simply add `workspacePackageName = "myPackageName"`. Cranix handles the rest 🦀.

## APIs

- `craneLib.build{Sys}DepsOnly`: A helper for `craneLib.buildDepsOnly`, including all previously explained integrations.
- `craneLib.build{Sys}Package`: A helper for `craneLib.buildPackageOnly`, including all previously explained integrations.
- `craneLib.build{Sys}CachedPackage`: Packs your system dependencies, package and `nix run` app. You're allowed to add `args.cargoArtifacts`.

## Supported Systems

- Windows x86_64 GNU ABI
- Linux x86_64 GNU ABI

Feel free to add `CARGO_{TRIPLE|COMMAND}_RUSTFLAG` or `nativeBuildInputs`. They won't break anything in the new APIs.

## How to use

```nix
{
  description = "My Custom Rust Project";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
    cranix.url = "git+file:/home/lemi/cranix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix.url = "github:nix-community/fenix/monthly";
  };
  outputs = {
    fenix,
    nixpkgs,
    flake-utils,
    crane,
    cranix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.lib; let
        toolchain = with fenix.packages.${system};
          combine [
            complete.cargo
            complete.clippy
            complete.rust-src
            complete.rustc
            complete.rustfmt
            complete.rust-std
            complete.rustc-codegen-cranelift-preview
            targets.x86_64-pc-windows-gnu.latest.rust-std
            targets.x86_64-unknown-linux-gnu.latest.rust-std
          ];
        craneLib = crane.lib.${system}.overrideToolchain toolchain;
        cranixLib = craneLib.overrideScope' (cranix.lib.${system}.craneOverride);

        commonArg = {
          src = ./.;
          doCheck = false;
        };
        linuxApp =
          cranixLib.buildLinuxCachedPackage (commonArg //{
          useMold = true;
          useCranelift = true;
        });
        windowsApp =
          cranixLib.buildWindowsCachedPackage commonArg;
      in {
        # nix build
        packages = {
          linux = linuxApp.pkg;
          windows = windowsApp.pkg
        };

        # nix run
        app {
          linux = linuxApp.app;
          windows = windowsApp.app;
        }

        # nix develop
        devShells.default = cranixLib.devShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            openssl.dev
            pkg-config
          ];
        };
      });
}
```
