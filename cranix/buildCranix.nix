{
  pkgs,
  system,
  prev,
  ...
}
: {
  buildPackageDerivation ? false,
  commonAttrs ? {},
  ...
}: args: let
  inherit (pkgs) callPackage;
  workspaceNaming = callPackage ./workspaceNaming.nix {inherit prev;} args;
  rustFlags = callPackage ./rustFlags.nix {} args;
  sanitizeArgs = callPackage ./sanitizeArgs.nix {} args;
  # Cranix integrations / helpers
  cranixIntegration = depsBuild:
    sanitizeArgs
    // (workspaceNaming depsBuild)
    // (
      if ((builtins.typeOf commonAttrs) == "lambda")
      then (commonAttrs args)
      else commonAttrs
    )
    // rustFlags;

  # Deps build
  deps = prev.buildDepsOnly ((cranixIntegration true)
    // {
      installPhase = "prepareAndInstallCargoArtifactsDir";
    });
in
  ## Output: (args: prev.build{Package|DepsOnly} (cranixIntegration Output + mkDerviation Args))
  if buildPackageDerivation
  then
    prev.buildPackage (
      (cranixIntegration false)
      // {
        cargoArtifacts =
          args.cargoArtifacts or deps;
      }
    )
  else deps
