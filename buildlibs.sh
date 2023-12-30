#!/bin/sh

# Builds all fnalibs for macOS, iOS, and tvOS.
# Written by Caleb Cornett.
# Usage: ./buildlibs [macos/ios/ios-sim/tvos/tvos-sim/all/clean]

# Handle usage errors...
function error() {
	echo "Usage: ./buildlibs [macos/ios/ios-sim/tvos/tvos-sim/all/clean]"
	exit 1
}

# Check that we received one argument
if [ $# -ne 1 ]; then
	error
fi

# Get the directories...
SDL_XCODE_DIR="SDL2/Xcode/SDL"
SDL_CMAKE_DIR="SDL2/builddir"
FNA3D_XCODE_DIR="FNA3D/Xcode-iOS"
FNA3D_CMAKE_DIR="FNA3D/builddir"
FAUDIO_XCODE_DIR="FAudio/Xcode-iOS"
FAUDIO_CMAKE_DIR="FAudio/builddir"
THEO_XCODE_DIR="Theorafile/Xcode-iOS"
TV_STUBS_DIR="tvStubs"
MVK_DIR="MoltenVK"
VKLOADER_CMAKE_DIR="Vulkan-Loader/builddir"

# Set the Xcode project names
SDL_PROJ="SDL.xcodeproj"
FNA3D_PROJ="FNA3D.xcodeproj"
FAUDIO_PROJ="FAudio.xcodeproj"
THEO_PROJ="theorafile.xcodeproj"
TV_STUBS_PROJ="tvStubs.xcodeproj"

# Conditionals...
MACOS=0
IOS=0
IOS_SIM=0
TVOS=0
TVOS_SIM=0

# Set conditionals from the argument
if [ $1 = "macos" ]; then
	MACOS=1
elif [ $1 = "ios" ]; then
	IOS=1
elif [ $1 = "ios-sim" ]; then
	IOS_SIM=1
elif [ $1 = "tvos" ]; then
	TVOS=1
elif [ $1 = "tvos-sim" ]; then
	TVOS_SIM=1
elif [ $1 = "all" ]; then
	MACOS=1
	IOS=1
	IOS_SIM=1
	TVOS=1
	TVOS_SIM=1
elif [ $1 = "clean" ]; then
	rm -rf ./bin/

	rm -rf $SDL_CMAKE_DIR
	rm -rf $FNA3D_CMAKE_DIR
	rm -rf $FAUDIO_CMAKE_DIR
	rm -f "Theorafile/libtheorafile.dylib"
	rm -rf $VKLOADER_CMAKE_DIR

	rm -rf $SDL_XCODE_DIR/build
	rm -rf $FNA3D_XCODE_DIR/build
	rm -rf $FAUDIO_XCODE_DIR/build
	rm -rf $THEO_XCODE_DIR/build
	rm -rf $TV_STUBS_DIR/build

	cd $MVK_DIR
	make clean
	cd ..

	exit 0
else
	error
fi

# Build the bin/ directories if needed
if [ ! -d "./bin" ]; then
	mkdir bin
	mkdir bin/macos

	mkdir bin/ios
	mkdir bin/ios/simulator
	mkdir bin/ios/device

	mkdir bin/tvos
	mkdir bin/tvos/simulator
	mkdir bin/tvos/device
fi

function buildSDL()
{
	# macOS
	if [ $MACOS = 1 ]; then
		mkdir -p $SDL_CMAKE_DIR
		cd $SDL_CMAKE_DIR
		cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
			-DSDL_STATIC=OFF \
			-DSDL_TEST=OFF \
			-DSDL2_DISABLE_SDL2MAIN=ON \
			-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9
		make
		cd ../..
		cp $SDL_CMAKE_DIR/libSDL2-2.0.0.dylib ./bin/macos
	fi

	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $SDL_XCODE_DIR/$SDL_PROJ -target "Static Library-iOS" -config Release -sdk iphonesimulator \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_XCODE_DIR/build/Release-iphonesimulator/libSDL2.a ./bin/ios/simulator
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $SDL_XCODE_DIR/$SDL_PROJ -target "Static Library-iOS" -config Release -sdk iphoneos \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_XCODE_DIR/build/Release-iphoneos/libSDL2.a ./bin/ios/device
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $SDL_XCODE_DIR/$SDL_PROJ -target "Static Library-tvOS" -config Release -sdk appletvsimulator \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_XCODE_DIR/build/Release-appletvsimulator/libSDL2.a ./bin/tvos/simulator
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $SDL_XCODE_DIR/$SDL_PROJ -target "Static Library-tvOS" -config Release -sdk appletvos \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_XCODE_DIR/build/Release-appletvos/libSDL2.a ./bin/tvos/device
	fi
}

function buildFNA3D()
{
	# macOS
	if [ $MACOS = 1 ]; then
		mkdir -p $FNA3D_CMAKE_DIR
		cd $FNA3D_CMAKE_DIR
		cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
			-DSDL2_INCLUDE_DIRS="$PWD/../../SDL2/include" \
			-DSDL2_LIBRARIES="$PWD/../../$SDL_CMAKE_DIR/libSDL2-2.0.0.dylib"
		make

		# HACK: Remove the LC_RPATH if it's set.
		# Ideally CMake could just NOT set this in the first place...
		local otoolOutput=$(otool -l libFNA3D.0.dylib)
		if [[ $otoolOutput == *"LC_RPATH"* ]]; then
			install_name_tool -delete_rpath "$PWD/../../$SDL_CMAKE_DIR" libFNA3D.0.dylib
		fi

		cd ../..
		cp $FNA3D_CMAKE_DIR/libFNA3D.0.dylib ./bin/macos
	fi

	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $FNA3D_XCODE_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk iphonesimulator
		cp $FNA3D_XCODE_DIR/build/Release-iphonesimulator/libFNA3D.a ./bin/ios/simulator
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $FNA3D_XCODE_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk iphoneos
		cp $FNA3D_XCODE_DIR/build/Release-iphoneos/libFNA3D.a ./bin/ios/device
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $FNA3D_XCODE_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk appletvsimulator
		cp $FNA3D_XCODE_DIR/build/Release-appletvsimulator/libFNA3D.a ./bin/tvos/simulator
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $FNA3D_XCODE_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk appletvos
		cp $FNA3D_XCODE_DIR/build/Release-appletvos/libFNA3D.a ./bin/tvos/device
	fi
}

function buildFAudio()
{
	# macOS
	if [ $MACOS = 1 ]; then
		mkdir -p $FAUDIO_CMAKE_DIR
		cd $FAUDIO_CMAKE_DIR
		cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
			-DSDL2_INCLUDE_DIRS="$PWD/../../SDL2/include" \
			-DSDL2_LIBRARIES="$PWD/../../$SDL_CMAKE_DIR/libSDL2-2.0.0.dylib"
		make

		# HACK: Remove the LC_RPATH if it's set.
		# Ideally CMake could just NOT set this in the first place...
		local otoolOutput=$(otool -l libFAudio.0.dylib)
		if [[ $otoolOutput == *"LC_RPATH"* ]]; then
			install_name_tool -delete_rpath "$PWD/../../$SDL_CMAKE_DIR" libFAudio.0.dylib
		fi

		cd ../..
		cp $FAUDIO_CMAKE_DIR/libFAudio.0.dylib ./bin/macos
	fi

	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $FAUDIO_XCODE_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk iphonesimulator
		cp $FAUDIO_XCODE_DIR/build/Release-iphonesimulator/libFAudio.a ./bin/ios/simulator
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $FAUDIO_XCODE_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk iphoneos
		cp $FAUDIO_XCODE_DIR/build/Release-iphoneos/libFAudio.a ./bin/ios/device
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $FAUDIO_XCODE_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk appletvsimulator
		cp $FAUDIO_XCODE_DIR/build/Release-appletvsimulator/libFAudio.a ./bin/tvos/simulator
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $FAUDIO_XCODE_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk appletvos
		cp $FAUDIO_XCODE_DIR/build/Release-appletvos/libFAudio.a ./bin/tvos/device
	fi
}

function buildTheorafile()
{
	# macOS
	if [ $MACOS = 1 ]; then
		cd Theorafile

		if [ -f "libtheorafile.dylib" ]; then
			rm libtheorafile.dylib
		fi

		# Theorafile uses different source files depending on arch.
		# Compile for x64...
		CC="cc -arch x86_64" make
		mv libtheorafile.dylib libtheorafile_x64.dylib

		# ...then for arm64...
		CC="cc -arch arm64" make
		mv libtheorafile.dylib libtheorafile_arm64.dylib

		# ...and lipo them together!
		lipo -create -output libtheorafile.dylib libtheorafile_x64.dylib libtheorafile_arm64.dylib
		rm libtheorafile_x64.dylib libtheorafile_arm64.dylib

		cd ..
		cp Theorafile/libtheorafile.dylib ./bin/macos
	fi

	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $THEO_XCODE_DIR/$THEO_PROJ -target theorafile -config Release -sdk iphonesimulator
		cp $THEO_XCODE_DIR/build/Release-iphonesimulator/libtheorafile.a ./bin/ios/simulator
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $THEO_XCODE_DIR/$THEO_PROJ -target theorafile -config Release -sdk iphoneos
		cp $THEO_XCODE_DIR/build/Release-iphoneos/libtheorafile.a ./bin/ios/device
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $THEO_XCODE_DIR/$THEO_PROJ -target theorafile -config Release -sdk appletvsimulator
		cp $THEO_XCODE_DIR/build/Release-appletvsimulator/libtheorafile.a ./bin/tvos/simulator
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $THEO_XCODE_DIR/$THEO_PROJ -target theorafile -config Release -sdk appletvos
		cp $THEO_XCODE_DIR/build/Release-appletvos/libtheorafile.a ./bin/tvos/device
	fi
}

# Only needed for tvOS.
# Builds various Windows/Android SDL2 stubs so that Xamarin won't complain about missing definitions.
function buildStubs()
{
	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $TV_STUBS_DIR/$TV_STUBS_PROJ -target tvStubs -config Release -sdk appletvsimulator
		cp $TV_STUBS_DIR/build/Release-appletvsimulator/libtvStubs.a ./bin/tvos/simulator
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $TV_STUBS_DIR/$TV_STUBS_PROJ -target tvStubs -config Release -sdk appletvos
		cp $TV_STUBS_DIR/build/Release-appletvos/libtvStubs.a ./bin/tvos/device
	fi
}

function buildMVK()
{
	# macOS
	if [ $MACOS = 1 ]; then
		# Build MoltenVK itself
		cd $MVK_DIR
		./fetchDependencies --macos -v
		make macos
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/dylib/macOS/libMoltenVK.dylib ./bin/macos

		# Build Vulkan-Loader
		mkdir -p $VKLOADER_CMAKE_DIR
		cd $VKLOADER_CMAKE_DIR
		cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
			-DUPDATE_DEPS=ON \
			-DVULKAN_HEADERS_INSTALL_DIR="$PWD/../../Vulkan-Headers" \
			-DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13
		make
		cd ../..
		cp $VKLOADER_CMAKE_DIR/loader/libvulkan.1.dylib ./bin/macos
	fi

	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --iossim -v
		make iossim
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/ios-arm64_x86_64-simulator/libMoltenVK.a ./bin/ios/simulator
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --ios -v
		make ios
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/ios-arm64/libMoltenVK.a ./bin/ios/device
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --tvossim -v
		make tvossim
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/tvos-arm64_x86_64-simulator/libMoltenVK.a ./bin/tvos/simulator
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --tvos -v
		make tvos
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/tvos-arm64_arm64e/libMoltenVK.a ./bin/tvos/device
	fi
}

# Build 'em all!
buildSDL && buildFNA3D && buildFAudio && buildTheorafile && buildStubs

while true; do
    read -p "Do you want to build MoltenVK as well? This is required for FNA3D, but building takes a while so it can be skipped on subsequent rebuilds. (y/n) " yn
    case $yn in
        [Yy]* ) buildMVK; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y/n.";;
    esac
done