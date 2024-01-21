{...}: args:
builtins.removeAttrs args [
  "useCranelift"
  "useMold"
  "isDepsBuild"
  "isLibTarget"
  "workspaceTargetName"
]
