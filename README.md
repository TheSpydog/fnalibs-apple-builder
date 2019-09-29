# fnalibs ios builder
Convenient download and build scripts for FNA's iOS / tvOS native libraries.

Run `./updatelibs` to automatically clone or pull all the fnalibs. When first cloning the repos, it also applies an FNA-specific patch for SDL2 and downloads the required [CMake toolchain file](https://github.com/leetal/ios-cmake) for MojoShader.

Run `./buildlibs [ios/ios-sim/ios-fat/tvos/tvos-sim/tvos-fat]` to build all libraries for the selected platform. It will place the resulting archives into a `release/` directory.
Note that building "*-fat" creates the combined archive as well as the individual simulator and device builds.

Run `./buildlibs clean` to remove all auto-generated build directories.

## dependencies

Requires `git`, `hg`, and `cmake` available from the terminal.
