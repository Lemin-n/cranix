{pkgs, ...}: let
  inherit (pkgs.lib.strings) optionalString;
  inherit (pkgs.lib.attrsets) optionalAttrs;
in
  {
    isDepsBuild ? false,
    workspacePackageName ? null,
    useTargetNaming ? true,
    ...
  } @ args: let
    pnameWorkspace = "-${workspacePackageName}";
    cargoExtraArgWorkspace = "--package ${workspacePackageName}";
    targetName = optionalString useTargetNaming args.CARGO_BUILD_TARGET or "";
    depsFlag = optionalString true "-deps";
  in
    optionalAttrs (workspacePackageName != null) {
      pnameSuffix = "${targetName}${pnameWorkspace}${depsFlag}${args.pnameSuffix or ""}";
      cargoExtraArgs = "${args.cargoExtraArgs or ""}${cargoExtraArgWorkspace}";
    }
