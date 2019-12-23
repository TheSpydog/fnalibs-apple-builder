#!/bin/sh

# Builds all fnalibs for iOS or tvOS.
# Written by Caleb Cornett.
# Usage: ./buildlibs [ios/ios-sim/ios-fat/tvos/tvos-sim/tvos-fat/clean]

#TODO: Support Debug configurations

# Handle usage errors...
function error() {
	echo "Usage: ./buildlibs [ios/ios-sim/ios-fat/tvos/tvos-sim/tvos-fat/clean]"
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
elif [ $1 = "clean" ]; then
	rm ./release/ios/device/*
	rm ./release/ios/simulator/*
	rm ./release/ios/fat/*
	rm ./release/tvos/device/*
	rm ./release/tvos/simulator/*
	rm ./release/tvos/fat/*

	rm -r ./SDL/Xcode-iOS/SDL/build
	rm -r ./SDL_image/Xcode-iOS/build
	rm -r ./FAudio/Xcode-iOS/build
	rm -r ./Theorafile/Xcode-iOS/build

	rm -r ./mojoshader/build-ios
	rm -r ./mojoshader/build-ios-sim
	rm -r ./mojoshader/build-tvos
	rm -r ./mojoshader/build-tvos-sim
	exit 0
else
	error
fi

# Get the directories...
SDL_DIR="SDL/Xcode-iOS/SDL"
IMG_DIR="SDL_image/Xcode-iOS"
FAUDIO_DIR="FAudio/Xcode-iOS"
THEO_DIR="Theorafile/Xcode-iOS"

SDL_PROJ="SDL.xcodeproj"
IMG_PROJ="SDL_image.xcodeproj"
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

function buildIMG() {
	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		xcodebuild -project $IMG_DIR/$IMG_PROJ -target libSDL_image-iOS -config Release -sdk iphonesimulator
		cp $IMG_DIR/build/Release-iphonesimulator/libSDL2_image.a ./release/ios/simulator/libSDL2_image.a
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		xcodebuild -project $IMG_DIR/$IMG_PROJ -target libSDL_image-iOS -config Release -sdk iphoneos
		cp $IMG_DIR/build/Release-iphoneos/libSDL2_image.a ./release/ios/device/libSDL2_image.a
	fi

	# iOS Combine
	if [ $IOS_FAT = 1 ]; then
		cp $IMG_DIR/build/Release-iphoneos/libSDL2_image.a ./libSDL2_image-device.a
		cp $IMG_DIR/build/Release-iphonesimulator/libSDL2_image.a ./libSDL2_image-simulator.a
		lipo -create libSDL2_image-device.a libSDL2_image-simulator.a -output ./release/ios/fat/libSDL2_image.a
		rm libSDL2_image-*
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		xcodebuild -project $IMG_DIR/$IMG_PROJ -target libSDL_image-tvOS -config Release -sdk appletvsimulator
		cp $IMG_DIR/build/Release-appletvsimulator/libSDL2_image.a ./release/tvos/simulator/libSDL2_image.a
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		xcodebuild -project $IMG_DIR/$IMG_PROJ -target libSDL_image-tvOS -config Release -sdk appletvos
		cp $IMG_DIR/build/Release-appletvos/libSDL2_image.a ./release/tvos/device/libSDL2_image.a
	fi

	# tvOS Combine
	if [ $TVOS_FAT = 1 ]; then
		cp $IMG_DIR/build/Release-appletvos/libSDL2_image.a ./libSDL2_image-device.a
		cp $IMG_DIR/build/Release-appletvsimulator/libSDL2_image.a ./libSDL2_image-simulator.a
		lipo -create libSDL2_image-device.a libSDL2_image-simulator.a -output ./release/tvos/fat/libSDL2_image.a
		rm libSDL2_image-*
	fi
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

function runMojoShaderCMake() {
	cmake .. -GXcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DIOS_PLATFORM=$1 -DPROFILE_D3D=OFF -DPROFILE_BYTECODE=OFF -DPROFILE_ARB1=OFF -DPROFILE_ARB1_NV=OFF -DCOMPILER_SUPPORT=OFF -DFLIP_VIEWPORT=ON -DDEPTH_CLIPPING=ON -DXNA4_VERTEXTEXTURE=ON
}

function buildMojoShader() {

	# Remember where we were...
	ORIG_DIR=`pwd`

	# Make the output build directories if needed
	if [ ! -d "./mojoshader/build-ios-sim" ]; then
		mkdir ./mojoshader/build-ios-sim
		mkdir ./mojoshader/build-ios
		mkdir ./mojoshader/build-tvos-sim
		mkdir ./mojoshader/build-tvos
	fi

	# iOS Simulator
	if [ $IOS_SIM = 1 ]; then
		cd ./mojoshader/build-ios-sim/
		runMojoShaderCMake SIMULATOR64
		xcodebuild -project MojoShader.xcodeproj ONLY_ACTIVE_ARCH=NO -target mojoshader -configuration Release clean build
		cp ./Release-iphonesimulator/libmojoshader.a $ORIG_DIR/release/ios/simulator/libmojoshader.a
		cd $ORIG_DIR
	fi

	# iOS Device
	if [ $IOS = 1 ]; then
		cd ./mojoshader/build-ios/
		runMojoShaderCMake OS64
		xcodebuild -project MojoShader.xcodeproj ONLY_ACTIVE_ARCH=NO -target mojoshader -configuration Release clean build
		cp ./Release-iphoneos/libmojoshader.a $ORIG_DIR/release/ios/device/libmojoshader.a
		cd $ORIG_DIR
	fi

	# iOS Combine
	if [ $IOS_FAT = 1 ]; then
		cp ./mojoshader/build-ios/Release-iphoneos/libmojoshader.a ./libmojoshader-device.a
		cp ./mojoshader/build-ios-sim/Release-iphonesimulator/libmojoshader.a ./libmojoshader-simulator.a
		lipo -create libmojoshader-device.a libmojoshader-simulator.a -output ./release/ios/fat/libmojoshader.a
		rm libmojoshader-*
	fi

	# tvOS Simulator
	if [ $TVOS_SIM = 1 ]; then
		cd ./mojoshader/build-tvos-sim/
		runMojoShaderCMake SIMULATOR_TVOS
		xcodebuild -project MojoShader.xcodeproj ONLY_ACTIVE_ARCH=NO -target mojoshader -configuration Release clean build
		cp ./Release-appletvsimulator/libmojoshader.a $ORIG_DIR/release/tvos/simulator/libmojoshader.a
		cd $ORIG_DIR
	fi

	# tvOS Device
	if [ $TVOS = 1 ]; then
		cd ./mojoshader/build-tvos/
		runMojoShaderCMake TVOS
		xcodebuild -project MojoShader.xcodeproj ONLY_ACTIVE_ARCH=NO -target mojoshader -configuration Release clean build
		cp ./Release-appletvos/libmojoshader.a $ORIG_DIR/release/tvos/device/libmojoshader.a
		cd $ORIG_DIR
	fi

	# tvOS Combine
	if [ $TVOS_FAT = 1 ]; then
		cp ./mojoshader/build-tvos/Release-appletvos/libmojoshader.a ./libmojoshader-device.a
		cp ./mojoshader/build-tvos-sim/Release-appletvsimulator/libmojoshader.a ./libmojoshader-simulator.a
		lipo -create libmojoshader-device.a libmojoshader-simulator.a -output ./release/tvos/fat/libmojoshader.a
		rm libmojoshader-*
	fi
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
buildIMG
buildFAudio
buildMojoShader
buildTheorafile
