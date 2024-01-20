{pkgs, ...}: let
  inherit (pkgs.lib.attrsets) optionalAttrs;
  inherit (pkgs.lib.strings) concatStringsSep;
  inherit (pkgs.lib.lists) optional;
in
  {
    useCranelift ? false,
    useMold ? false,
    CARGO_BUILD_RUSTFLAGS ? "",
    nativeBuildInputs ? [],
    ...
  }: let
    craneliftFlag = optional useCranelift "-Zcodegen-backend=cranelift";
    moldFlag = optional useMold "-C link-arg=-fuse-ld=mold";
    buildInput = with pkgs; (optional useMold [mold]) ++ nativeBuildInputs;
  in
    optionalAttrs (useCranelift || useMold) {
      CARGO_BUILD_RUSTFLAGS = concatStringsSep " " (craneliftFlag ++ moldFlag ++ [CARGO_BUILD_RUSTFLAGS]);
      nativeBuildInputs = buildInput;
    }
