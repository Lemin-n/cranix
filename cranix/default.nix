{
  pkgs,
  system,
  ...
}: let
  inherit (pkgs) callPackage;
in
  final: prev: rec {
    buildWindowsDepsOnly = callPackage ./buildWindowsDepsOnly.nix {inherit prev;};
    buildWindowsPackage = callPackage ./buildWindowsPackage.nix {inherit prev buildWindowsDepsOnly;};
    buildWindowsCachedPackage = callPackage ./buildWindowsCachedPackage.nix {inherit buildWindowsDepsOnly buildWindowsPackage;};
    buildLinuxDepsOnly = callPackage ./buildLinuxDepsOnly.nix {inherit prev;};
    buildLinuxPackage = callPackage ./buildLinuxPackage.nix {inherit prev buildLinuxDepsOnly;};
    buildLinuxCachedPackage = callPackage ./buildLinuxCachedPackage.nix {inherit buildLinuxDepsOnly buildLinuxPackage;};
  }
