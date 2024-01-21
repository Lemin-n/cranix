{pkgs, ...}: let
  inherit (pkgs.lib.strings) optionalString;
  inherit (pkgs.lib.attrsets) optionalAttrs;
in
  {
    isDepsBuild ? false,
    workspaceTargetName ? null,
    isLibTarget ? false,
    ...
  } @ args: let
    extraTargetFlag =
      if isLibTarget
      then "lib"
      else "bin";
    cargoExtraArgWorkspace = "--${extraTargetFlag} ${workspaceTargetName}";
    depsFlag = optionalString isDepsBuild "${args.pname or ""}-${workspaceTargetName}-deps";
  in
    optionalAttrs (workspaceTargetName != null) {
      pname = "${workspaceTargetName}${depsFlag}";
      cargoExtraArgs = "${args.cargoExtraArgs or ""}${cargoExtraArgWorkspace}";
    }
