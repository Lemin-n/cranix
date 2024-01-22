{
  pkgs,
  system,
  ...
}: let
  inherit (pkgs) callPackage;
in
  final: prev: let
    commonWindowsArgs = callPackage ./commonWindowsArgs.nix {};
    commonLinuxArgs = import ./commonLinuxArgs.nix;
    buildCranix = callPackage ./buildCranix.nix {inherit prev;};
    _buildCranixBundle = callPackage ./buildCranixBundle.nix {inherit prev;};
  in rec
  {
    buildWindowsDepsOnly = buildCranix {commonArgs = commonWindowsArgs;};
    buildWindowsPackage = buildCranix {
      commonArgs = commonWindowsArgs;
      buildPackageDerivation = true;
    };
    buildWindowsBundle = _buildCranixBundle {inherit buildWindowsDepsOnly buildWindowsPackage;};
    buildLinuxDepsOnly = buildCranix {commonArgs = commonLinuxArgs;};
    buildLinuxPackage = buildCranix {
      commonArgs = commonLinuxArgs;
      buildPackageDerivation = true;
    };
    buildLinuxBundle = _buildCranixBundle {
      buildDepsOnly = buildLinuxDepsOnly;
      buildPackage = buildLinuxPackage;
    };
    buildCranixDepsOnly = buildCranix {};
    buildCranixPackage = buildCranix {
      buildPackageDerivation = true;
    };
    buildCranixBundle = _buildCranixBundle buildCranixDepsOnly buildCranixPackage;
  }
