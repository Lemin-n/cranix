{...}: args:
builtins.removeAttrs args [
  "useCranelift"
  "useMold"
  "isDepsBuild"
  "useTargetNaming"
  "workspacePackageName"
]
