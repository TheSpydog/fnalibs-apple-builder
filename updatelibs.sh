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

if [ ! -d "./SDL_image/" ]; then
	echo "SDL_image folder not found. Cloning now..."
	hg clone https://hg.libsdl.org/SDL_image/

	echo ""
fi

if [ ! -d "./FAudio/" ]; then
	echo "FAudio folder not found. Cloning now..."
	git clone https://github.com/FNA-XNA/FAudio.git

	echo ""
fi

if [ ! -d "./MojoShader/" ]; then
	echo "MojoShader folder not found. Cloning now..."
	git clone --branch fna https://github.com/FNA-XNA/MojoShader

	# Download the iOS CMake toolchain file too for convenience
	echo ""
	echo "Downloading ios.toolchain.cmake [https://github.com/leetal/ios-cmake] for convenience..."
	cd MojoShader && curl -O https://raw.githubusercontent.com/leetal/ios-cmake/master/ios.toolchain.cmake && cd ..

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
echo "Updating SDL_image..."
cd SDL_image && hg pull -u && cd ..

echo ""
echo "Updating FAudio..."
cd FAudio && git pull && cd ..

echo ""
echo "Updating MojoShader..."
cd mojoshader && git pull && cd ..

echo ""
echo "Updating Theorafile..."
cd Theorafile && git pull && cd ..
