{
  pkgs,
  system,
  prev,
  ...
}
: builders @ {
  buildDepsOnly ? prev.buildDepsOnly,
  buildPackage ? prev.buildPackage,
  ...
}: args: rec {
  deps = args.cargoArtifacts or ((builders.buildDepsOnly or buildDepsOnly) args);
  pkg = builders.buildPackage or buildPackage (args // {cargoArtifacts = deps;});
  app = {
    type = "app";
    program = "${pkg}${pkg.passthru.exePath or "/bin/${pkg.pname or pkg.name}"}";
  };
}
