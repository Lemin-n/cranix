{
  pkgs,
  system,
  prev,
  buildWindowsDepsOnly,
  ...
}
: let
  inherit (pkgs) callPackage;
  workspaceNaming = callPackage ./workspaceNaming.nix {};
  commonWindowsArgs = callPackage ./commonWindowsArgs.nix {};
  rustFlags = callPackage ./rustFlags.nix {};
  sanitizeArgs = callPackage ./sanitizeArgs.nix {};
in
  args: let
    attrs =
      (sanitizeArgs args)
      // (commonWindowsArgs args)
      // (workspaceNaming args)
      // (rustFlags args);
  in
    prev.buildPackage (
      attrs
      // {
        cargoArtifacts =
          args.cargoArtifacts
          or (buildWindowsDepsOnly (
            args
            // {
              installPhase = "prepareAndInstallCargoArtifactsDir";
            }
          ));
      }
    )
