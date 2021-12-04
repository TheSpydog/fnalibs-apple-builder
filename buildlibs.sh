#!/bin/sh

# Builds all fnalibs for iOS or tvOS.
# Written by Caleb Cornett.
# Usage: ./buildlibs [ios/ios-sim/tvos/tvos-sim/all/clean]

#TODO: Support Debug configurations

# Handle usage errors...
function error() {
	echo "Usage: ./buildlibs [ios/ios-sim/tvos/tvos-sim/all/clean]"
	exit 1
}

# Check that we received one argument
if [ $# -ne 1 ]; then
	error
fi

# Get the directories...
SDL_DIR="SDL2/Xcode/SDL"
FNA3D_DIR="FNA3D/Xcode-iOS"
FAUDIO_DIR="FAudio/Xcode-iOS"
THEO_DIR="Theorafile/Xcode-iOS"
STUBS_DIR="tvStubs"
MVK_DIR="MoltenVK"

SDL_PROJ="SDL.xcodeproj"
FNA3D_PROJ="FNA3D.xcodeproj"
FAUDIO_PROJ="FAudio.xcodeproj"
THEO_PROJ="theorafile.xcodeproj"
STUBS_PROJ="tvStubs.xcodeproj"
# MVK uses a Makefile

# Conditionals...
IOS=0
IOS_SIM=0
TVOS=0
TVOS_SIM=0

# Set conditionals from the argument
if [ $1 = "ios" ]; then
	IOS=1
elif [ $1 = "ios-sim" ]; then
	IOS_SIM=1
elif [ $1 = "tvos" ]; then
	TVOS=1
elif [ $1 = "tvos-sim" ]; then
	TVOS_SIM=1
elif [ $1 = "all" ]; then
	IOS=1
	IOS_SIM=1
	TVOS=1
	TVOS_SIM=1
elif [ $1 = "clean" ]; then
	rm ./release/ios/device/*
	rm ./release/ios/simulator/*
	rm ./release/tvos/device/*
	rm ./release/tvos/simulator/*

	rm -r $SDL_DIR/build
	rm -r $FNA3D_DIR/build
	rm -r $FAUDIO_DIR/build
	rm -r $THEO_DIR/build
	rm -r $STUBS_DIR/build

	cd $MVK_DIR
	make clean
	cd ..

	exit 0
else
	error
fi

# Build the release/ directories if needed
if [ ! -d "./release" ]; then
	mkdir release

	mkdir release/ios
	mkdir release/ios/simulator
	mkdir release/ios/device

	mkdir release/tvos
	mkdir release/tvos/simulator
	mkdir release/tvos/device
fi

function buildSDL()
{
	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-iOS" -config Release -sdk iphonesimulator \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_DIR/build/Release-iphonesimulator/libSDL2.a ./release/ios/simulator/libSDL2.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-iOS" -config Release -sdk iphoneos \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_DIR/build/Release-iphoneos/libSDL2.a ./release/ios/device/libSDL2.a
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-tvOS" -config Release -sdk appletvsimulator \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_DIR/build/Release-appletvsimulator/libSDL2.a ./release/tvos/simulator/libSDL2.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-tvOS" -config Release -sdk appletvos \
			GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SDL_MAIN_HANDLED=1'
		cp $SDL_DIR/build/Release-appletvos/libSDL2.a ./release/tvos/device/libSDL2.a
	fi
}

function buildFNA3D()
{
	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $FNA3D_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk iphonesimulator
		cp $FNA3D_DIR/build/Release-iphonesimulator/libFNA3D.a ./release/ios/simulator/libFNA3D.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $FNA3D_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk iphoneos
		cp $FNA3D_DIR/build/Release-iphoneos/libFNA3D.a ./release/ios/device/libFNA3D.a
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $FNA3D_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk appletvsimulator
		cp $FNA3D_DIR/build/Release-appletvsimulator/libFNA3D.a ./release/tvos/simulator/libFNA3D.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $FNA3D_DIR/$FNA3D_PROJ -target FNA3D -config Release -sdk appletvos
		cp $FNA3D_DIR/build/Release-appletvos/libFNA3D.a ./release/tvos/device/libFNA3D.a
	fi
}

function buildFAudio()
{
	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $FAUDIO_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk iphonesimulator
		cp $FAUDIO_DIR/build/Release-iphonesimulator/libFAudio.a ./release/ios/simulator/libFAudio.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $FAUDIO_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk iphoneos
		cp $FAUDIO_DIR/build/Release-iphoneos/libFAudio.a ./release/ios/device/libFAudio.a
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $FAUDIO_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk appletvsimulator
		cp $FAUDIO_DIR/build/Release-appletvsimulator/libFAudio.a ./release/tvos/simulator/libFAudio.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $FAUDIO_DIR/$FAUDIO_PROJ -target FAudio -config Release -sdk appletvos
		cp $FAUDIO_DIR/build/Release-appletvos/libFAudio.a ./release/tvos/device/libFAudio.a
	fi
}

function buildTheorafile()
{
	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $THEO_DIR/$THEO_PROJ -target theorafile -config Release -sdk iphonesimulator
		cp $THEO_DIR/build/Release-iphonesimulator/libtheorafile.a ./release/ios/simulator/libtheorafile.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $THEO_DIR/$THEO_PROJ -target theorafile -config Release -sdk iphoneos
		cp $THEO_DIR/build/Release-iphoneos/libtheorafile.a ./release/ios/device/libtheorafile.a
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $THEO_DIR/$THEO_PROJ -target theorafile -config Release -sdk appletvsimulator
		cp $THEO_DIR/build/Release-appletvsimulator/libtheorafile.a ./release/tvos/simulator/libtheorafile.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $THEO_DIR/$THEO_PROJ -target theorafile -config Release -sdk appletvos
		cp $THEO_DIR/build/Release-appletvos/libtheorafile.a ./release/tvos/device/libtheorafile.a
	fi
}

# Only needed for tvOS.
# Builds various Windows/Android SDL2 stubs so that Xamarin won't complain about missing definitions.
function buildStubs()
{
	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $STUBS_DIR/$STUBS_PROJ -target tvStubs -config Release -sdk appletvsimulator
		cp $STUBS_DIR/build/Release-appletvsimulator/libtvStubs.a ./release/tvos/simulator/libtvStubs.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $STUBS_DIR/$STUBS_PROJ -target tvStubs -config Release -sdk appletvos
		cp $STUBS_DIR/build/Release-appletvos/libtvStubs.a ./release/tvos/device/libtvStubs.a
	fi
}

function buildMVK()
{
	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --iossim -v
		make iossim
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/ios-arm64_x86_64-simulator/libMoltenVK.a ./release/ios/simulator/libMoltenVK.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --ios -v
		make ios
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/ios-arm64/libMoltenVK.a ./release/ios/device/libMoltenVK.a
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --tvossim -v
		make tvossim
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/tvos-arm64_x86_64-simulator/libMoltenVK.a ./release/tvos/simulator/libMoltenVK.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		cd $MVK_DIR
		./fetchDependencies --tvos -v
		make tvos
		cd ..
		cp $MVK_DIR/Package/Release/MoltenVK/MoltenVK.xcframework/tvos-arm64_arm64e/libMoltenVK.a ./release/tvos/device/libMoltenVK.a
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