# fnalibs appleBuilder
Convenient download and build scripts for FNA's macOS / iOS / tvOS native libraries.

Run `./updatelibs` to automatically clone or pull all the fnalibs.

Run `./buildlibs [macos/ios/ios-sim/tvos/tvos-sim/all]` to build all libraries for the selected platform. It will place the resulting archives into a `bin/` directory.

Run `./buildlibs clean` to remove all auto-generated build directories.

## dependencies

Requires `git`, `cmake`, `python3`, and a recent version of Xcode Command Line Tools.
