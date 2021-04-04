#!/bin/sh

# Clones or pulls the latest fnalibs.
# Intended for use with FNA on iOS / tvOS.
# Requires git to be installed.
# Written by Caleb Cornett.
# Usage: ./updatelibs.sh

# Clone repos if needed
if [ ! -d "./SDL2/" ]; then
	echo "SDL2 folder not found. Cloning now..."
	git clone https://github.com/libsdl-org/SDL.git SDL2

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
echo "Updating SDL2..."
cd SDL2 && git pull && cd ..

# Apply the IOS_DYLIB=1 patch for convenience
echo ""
echo "Applying SDL2 iOS patch for convenience..."
cd SDL2
# Reset in case local changes made the patch incompatible
git reset --hard
# Apply patch
git apply ../sdl2_fna_ios.patch
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
