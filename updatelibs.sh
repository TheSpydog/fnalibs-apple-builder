#!/bin/sh

# Clones or pulls the latest fnalibs.
# Intended for use with FNA on iOS / tvOS.
# Requires both hg and git.
# Written by Caleb Cornett.
# Usage: ./updatelibs.sh

# Clone repos if needed
if [ ! -d "./SDL/" ]; then
	echo "SDL folder not found. Cloning now..."
	hg clone https://hg.libsdl.org/SDL/

	echo ""
fi

if [ ! -d "./FNA3D/" ]; then
	echo "FNA3D folder not found. Cloning now..."
	git clone https://github.com/FNA-XNA/FNA3D.git --recursive

	echo ""
fi

if [ ! -d "./FAudio/" ]; then
	echo "FAudio folder not found. Cloning now..."
	git clone https://github.com/FNA-XNA/FAudio.git

	echo ""
fi

if [ ! -d "./Theorafile/" ]; then
	echo "Theorafile folder not found. Cloning now..."
	git clone https://github.com/FNA-XNA/Theorafile

	echo ""
fi

# Check for updates...
echo "Updating SDL..."
cd SDL && hg pull -u && cd ..

# Apply the IOS_DYLIB=1 / tvOS stub patch for convenience
echo ""
echo "Applying iOS/tvOS patch for convenience..."
cd SDL
# Reset back to pristine
hg update -r default -C && hg st -un0 | xargs -0 rm
# Apply patch
hg import --no-commit ../sdl2_fna_ios.patch
cd ..

echo ""
echo "Updating FNA3D..."
cd FNA3D && git pull && git submodule update && cd ..

echo ""
echo "Updating FAudio..."
cd FAudio && git pull && cd ..

echo ""
echo "Updating Theorafile..."
cd Theorafile && git pull && cd ..
