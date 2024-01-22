{
  pkgs,
  prev,
  ...
}: let
  inherit (pkgs.lib.strings) optionalString;
  inherit (pkgs.lib.attrsets) optionalAttrs;
in
  {
    workspaceTargetName ? null,
    isLibTarget ? false,
    ...
  } @ args: isDepsBuild: let
    extraTargetFlag =
      if args.isLibTarget or isLibTarget
      then "lib"
      else "bin";
    crateName = prev.crateNameFromCargoToml args;
    cargoExtraArgWorkspace = "--${extraTargetFlag} ${args.workspaceTargetName}";
    depsFlag = optionalString isDepsBuild "-${crateName.pname}-deps";
  in
    optionalAttrs (builtins.typeOf (args.workspaceTargetName or workspaceTargetName) != "null") {
      pnameSuffix = depsFlag;
      pname = "${args.workspaceTargetName}";
      cargoExtraArgs = "${args.cargoExtraArgs or ""}${cargoExtraArgWorkspace}";
    }
