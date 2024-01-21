{
  buildWindowsDepsOnly,
  buildWindowsPackage,
  ...
}: args: rec {
  deps = args.cargoArtifacts or buildWindowsDepsOnly args;
  pkg = buildWindowsPackage (args // {cargoArtifacts = deps;});
  app = {
    type = "app";
    program = "${pkg}${pkg.passthru.exePath or "/bin/${pkg.pname or pkg.name}"}";
  };
}
