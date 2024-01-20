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
    memoizedArgs =
      (sanitizeArgs args)
      // (commonWindowsArgs args)
      // (workspaceNaming args)
      // (rustFlags args);
  in
    prev.buildPackage (
      memoizedArgs
      // {
        cargoArtifacts =
          args.cargoArtifacts
          or (buildWindowsDepsOnly (memoizedArgs
            // {
              installPhase = "prepareAndInstallCargoArtifactsDir";
            }));
      }
    )
