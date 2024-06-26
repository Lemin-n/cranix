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
    crateName = prev.crateNameFromCargoToml args;
    depsFlag = optionalString isDepsBuild "-${crateName.pname}-deps";
  in
    optionalAttrs (builtins.typeOf (args.workspaceTargetName or workspaceTargetName) != "null") {
      pnameSuffix = depsFlag;
      pname = "${args.workspaceTargetName}";
    }
