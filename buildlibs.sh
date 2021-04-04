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

SDL_PROJ="SDL.xcodeproj"
FNA3D_PROJ="FNA3D.xcodeproj"
FAUDIO_PROJ="FAudio.xcodeproj"
THEO_PROJ="theorafile.xcodeproj"

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
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-iOS" -config Release -sdk iphonesimulator
		cp $SDL_DIR/build/Release-iphonesimulator/libSDL2.a ./release/ios/simulator/libSDL2.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-iOS" -config Release -sdk iphoneos
		cp $SDL_DIR/build/Release-iphoneos/libSDL2.a ./release/ios/device/libSDL2.a
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-tvOS" -config Release -sdk appletvsimulator
		cp $SDL_DIR/build/Release-appletvsimulator/libSDL2.a ./release/tvos/simulator/libSDL2.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target "Static Library-tvOS" -config Release -sdk appletvos
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

# Build 'em all!
buildSDL
buildFNA3D
buildFAudio
buildTheorafile
