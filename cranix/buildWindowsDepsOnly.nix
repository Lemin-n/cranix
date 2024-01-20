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
  commonWindowsArgs = callPackage ./commonWindowsArgs.nix {};
  rustFlags = callPackage ./rustFlags.nix {};
  sanitizeArgs = callPackage ./sanitizeArgs.nix {};
in
  args:
    prev.buildDepsOnly (
      (sanitizeArgs args)
      // (commonWindowsArgs args)
      // (workspaceNaming args // {inherit isDepsBuild;})
      // (rustFlags args)
    )
