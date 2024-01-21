{
  buildLinuxDepsOnly,
  buildLinuxPackage,
  ...
}: args: rec {
  deps = args.cargoArtifacts or (buildLinuxDepsOnly args);
  pkg = buildLinuxPackage (args // {cargoArtifacts = deps;});
  app = {
    type = "app";
    program = "${pkg}${pkg.passthru.exePath or "/bin/${pkg.pname or pkg.name}"}";
  };
}
