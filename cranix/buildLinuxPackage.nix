{
  pkgs,
  system,
  prev,
  buildLinuxDepsOnly,
  ...
}
: let
  inherit (pkgs) callPackage;
  workspaceNaming = callPackage ./workspaceNaming.nix {};
  commonLinuxArgs = import ./commonLinuxArgs.nix;
  rustFlags = callPackage ./rustFlags.nix {};
  sanitizeArgs = callPackage ./sanitizeArgs.nix {};
in
  args: let
    memoizedArgs =
      (sanitizeArgs args)
      // commonLinuxArgs
      // (workspaceNaming args)
      // (rustFlags args);
  in
    prev.buildPackage (
      memoizedArgs
      // {
        cargoArtifacts =
          args.cargoArtifacts
          or (buildLinuxDepsOnly (
            memoizedArgs
            // {
              installPhase = "prepareAndInstallCargoArtifactsDir";
            }
          ));
      }
    )
