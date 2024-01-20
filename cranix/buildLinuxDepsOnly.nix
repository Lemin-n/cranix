{
  pkgs,
  system,
  prev,
  ...
}
: let
  inherit (pkgs) callPackage;
  isDepsBuild = true;
  workspaceNaming = callPackage ./workspaceNaming.nix {};
  commonLinuxArgs = import ./commonLinuxArgs.nix;
  rustFlags = callPackage ./rustFlags.nix {};
  sanitizeArgs = callPackage ./sanitizeArgs.nix {};
in
  args:
    prev.buildDepsOnly (
      (sanitizeArgs args)
      // commonLinuxArgs
      // (workspaceNaming args // {inherit isDepsBuild;})
      // (rustFlags args)
    )
