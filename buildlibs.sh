#!/bin/sh

# Builds all fnalibs for iOS or tvOS.
# Written by Caleb Cornett.
# Usage: ./buildlibs [ios/ios-sim/ios-fat/tvos/tvos-sim/tvos-fat/all/clean]

#TODO: Support Debug configurations

# Handle usage errors...
function error() {
	echo "Usage: ./buildlibs [ios/ios-sim/ios-fat/tvos/tvos-sim/tvos-fat/all/clean]"
	exit 1
}

# Check that we received one argument
if [ $# -ne 1 ]; then
	error
fi

# Conditionals...
IOS=0
IOS_SIM=0
IOS_FAT=0

TVOS=0
TVOS_SIM=0
TVOS_FAT=0

# Set conditionals from the argument

if [ $1 = "ios" ]; then
	IOS=1
elif [ $1 = "ios-sim" ]; then
	IOS_SIM=1
elif [ $1 = "ios-fat" ]; then
	IOS=1
	IOS_SIM=1
	IOS_FAT=1
elif [ $1 = "tvos" ]; then
	TVOS=1
elif [ $1 = "tvos-sim" ]; then
	TVOS_SIM=1
elif [ $1 = "tvos-fat" ]; then
	TVOS=1
	TVOS_SIM=1
	TVOS_FAT=1
elif [ $1 = "all" ]; then
	IOS=1
	IOS_SIM=1
	IOS_FAT=1
	TVOS=1
	TVOS_SIM=1
	TVOS_FAT=1
elif [ $1 = "clean" ]; then
	rm ./release/ios/device/*
	rm ./release/ios/simulator/*
	rm ./release/ios/fat/*
	rm ./release/tvos/device/*
	rm ./release/tvos/simulator/*
	rm ./release/tvos/fat/*

	rm -r ./SDL/Xcode-iOS/SDL/build
	rm -r ./FNA3D/Xcode-iOS/build
	rm -r ./FAudio/Xcode-iOS/build
	rm -r ./Theorafile/Xcode-iOS/build

	exit 0
else
	error
fi

# Get the directories...
SDL_DIR="SDL/Xcode-iOS/SDL"
FNA3D_DIR="FNA3D/Xcode-iOS"
FAUDIO_DIR="FAudio/Xcode-iOS"
THEO_DIR="Theorafile/Xcode-iOS"

SDL_PROJ="SDL.xcodeproj"
FNA3D_PROJ="FNA3D.xcodeproj"
FAUDIO_PROJ="FAudio.xcodeproj"
THEO_PROJ="theorafile.xcodeproj"

# Build the release/ directories if needed
if [ ! -d "./release" ]; then
	mkdir release

	mkdir release/ios
	mkdir release/ios/simulator
	mkdir release/ios/fat
	mkdir release/ios/device

	mkdir release/tvos
	mkdir release/tvos/simulator
	mkdir release/tvos/fat
	mkdir release/tvos/device
fi

function buildSDL() {

	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target libSDL-iOS -config Release -sdk iphonesimulator
		cp $SDL_DIR/build/Release-iphonesimulator/libSDL2.a ./release/ios/simulator/libSDL2.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target libSDL-iOS -config Release -sdk iphoneos
		cp $SDL_DIR/build/Release-iphoneos/libSDL2.a ./release/ios/device/libSDL2.a
	fi

	# iOS Combine
	if [ $IOS_FAT = 1 ]; then
		cp $SDL_DIR/build/Release-iphoneos/libSDL2.a ./libSDL2-device.a
		cp $SDL_DIR/build/Release-iphonesimulator/libSDL2.a ./libSDL2-simulator.a
		lipo -create libSDL2-device.a libSDL2-simulator.a -output ./release/ios/fat/libSDL2.a
		rm libSDL2-*
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target libSDL-tvOS -config Release -sdk appletvsimulator
		cp $SDL_DIR/build/Release-appletvsimulator/libSDL2.a ./release/tvos/simulator/libSDL2.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $SDL_DIR/$SDL_PROJ -target libSDL-tvOS -config Release -sdk appletvos
		cp $SDL_DIR/build/Release-appletvos/libSDL2.a ./release/tvos/device/libSDL2.a
	fi

	# tvOS Combine
	if [ $TVOS_FAT = 1 ]; then
		cp $SDL_DIR/build/Release-appletvos/libSDL2.a ./libSDL2-device.a
		cp $SDL_DIR/build/Release-appletvsimulator/libSDL2.a ./libSDL2-simulator.a
		lipo -create libSDL2-device.a libSDL2-simulator.a -output ./release/tvos/fat/libSDL2.a
		rm libSDL2-*
	fi
}

function buildFNA3D() {
	# Workaround for FNA3D's dependency on SDL2/ and not SDL/
	mv ./SDL ./SDL2

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

	# iOS Combine
	if [ $IOS_FAT = 1 ]; then
		cp $FNA3D_DIR/build/Release-iphoneos/libFNA3D.a ./libFNA3D-device.a
		cp $FNA3D_DIR/build/Release-iphonesimulator/libFNA3D.a ./libFNA3D-simulator.a
		lipo -create libFNA3D-device.a libFNA3D-simulator.a -output ./release/ios/fat/libFNA3D.a
		rm libFNA3D-*
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

	# tvOS Combine
	if [ $TVOS_FAT = 1 ]; then
		cp $FNA3D_DIR/build/Release-appletvos/libFNA3D.a ./libFNA3D-device.a
		cp $FNA3D_DIR/build/Release-appletvsimulator/libFNA3D.a ./libFNA3D-simulator.a
		lipo -create libFNA3D-device.a libFNA3D-simulator.a -output ./release/tvos/fat/libFNA3D.a
		rm libFNA3D-*
	fi

	# Undo the SDL/ directory name change
	mv ./SDL2 ./SDL
}

function buildFAudio() {
	# Workaround for FAudio's dependency on SDL2/ and not SDL/
	mv ./SDL ./SDL2

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

	# iOS Combine
	if [ $IOS_FAT = 1 ]; then
		cp $FAUDIO_DIR/build/Release-iphoneos/libFAudio.a ./libFAudio-device.a
		cp $FAUDIO_DIR/build/Release-iphonesimulator/libFAudio.a ./libFAudio-simulator.a
		lipo -create libFAudio-device.a libFAudio-simulator.a -output ./release/ios/fat/libFAudio.a
		rm libFAudio-*
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

	# tvOS Combine
	if [ $TVOS_FAT = 1 ]; then
		cp $FAUDIO_DIR/build/Release-appletvos/libFAudio.a ./libFAudio-device.a
		cp $FAUDIO_DIR/build/Release-appletvsimulator/libFAudio.a ./libFAudio-simulator.a
		lipo -create libFAudio-device.a libFAudio-simulator.a -output ./release/tvos/fat/libFAudio.a
		rm libFAudio-*
	fi

	# Undo the SDL/ directory name change
	mv ./SDL2 ./SDL
}

function buildTheorafile() {
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

	# iOS Combine
	if [ $IOS_FAT = 1 ]; then
		cp $THEO_DIR/build/Release-iphoneos/libtheorafile.a ./libtheorafile-device.a
		cp $THEO_DIR/build/Release-iphonesimulator/libtheorafile.a ./libtheorafile-simulator.a
		lipo -create libtheorafile-device.a libtheorafile-simulator.a -output ./release/ios/fat/libtheorafile.a
		rm libtheorafile-*
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

	# tvOS Combine
	if [ $TVOS_FAT = 1 ]; then
		cp $THEO_DIR/build/Release-appletvos/libtheorafile.a ./libtheorafile-device.a
		cp $THEO_DIR/build/Release-appletvsimulator/libtheorafile.a ./libtheorafile-simulator.a
		lipo -create libtheorafile-device.a libtheorafile-simulator.a -output ./release/tvos/fat/libtheorafile.a
		rm libtheorafile-*
	fi
}

# Build 'em all!
buildSDL
buildFNA3D
buildFAudio
buildTheorafile
