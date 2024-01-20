{pkgs, ...}:
with pkgs.pkgsCross;
  args: {
    CARGO_TARGET_X86_64_PC_WINDOWS_GNU_RUSTFLAGS = "-L native=${mingwW64.windows.pthreads}/lib ${args.CARGO_TARGET_X86_64_PC_WINDOWS_GNU_RUSTFLAGS or ""}";
    CARGO_BUILD_TARGET = "x86_64-pc-windows-gnu";
    doCheck = args.doCheck or false;
    depsBuildBuild = [
      mingwW64.stdenv.cc
    ];
  }
