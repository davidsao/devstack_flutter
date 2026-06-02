#!/bin/bash

# 1. Start in the directory where the script is located
cd "$(dirname -- "${BASH_SOURCE[0]}")" || exit

YELLOW='\033[1;33m'
RED='\033[1;31m'
BLACK='\033[0;30m'

while getopts p:f:m: flag
do
    case "${flag}" in
        p) platform="${OPTARG}";;
        m) method="${OPTARG}";;
        *) ;;
    esac
done

# 2. Move to the project root (assumes the script is inside a folder like /scripts)
cd ../

# 3. Clean and recreate output directories using standard rm -rf
rm -rf outputs
mkdir -p outputs

rm -rf build/app/outputs
mkdir -p build/app/outputs

rm -rf build/ios/ipa
mkdir -p build/ios/ipa

# ==========================================
# ANDROID
# ==========================================
if [ "$platform" == "android" ] || [ -z "$platform" ]
then
  target="lib/main.dart"
  output=$method;
  if [ -z "$method" ]
  then
    output="apk" # or appbundle
  fi

  flutter build $output --split-debug-info --obfuscate -t $target --release --no-tree-shake-icons

  if [ "$output" == "apk" ]
  then
     FILE=$(find build/app/outputs/flutter-apk -name "app-release.apk")
     mv "$FILE" outputs/
  else
    FILE=$(find build/app/outputs/bundle/release -name "*.aab")
    mv "$FILE" outputs/
  fi
fi

# ==========================================
# IOS
# ==========================================
if [ "$platform" == "ios" ] || [ -z "$platform" ]
then
    output=$method;
    if [ -z "$method" ]
     then
       output="development"
     fi
    target="lib/main.dart"

    flutter build ipa --obfuscate --split-debug-info -t $target --release --export-method $output
    FILE=$(ls build/ios/ipa/*.ipa | head -1)
    mv "$FILE" outputs/"app.ipa"
fi

# ==========================================
# MACOS
# ==========================================
if [ "$platform" == "macos" ] || [ -z "$platform" ]
then
    target="lib/main.dart"

    echo -e "${YELLOW}Building Flutter macOS assets...${BLACK}"
    flutter build macos --obfuscate --split-debug-info -t $target --release

    if [ "$method" == "archive" ]
    then
        echo -e "${YELLOW}Generating .xcarchive via xcodebuild...${BLACK}"

        # Clean previous archives
        rm -rf build/macos/Archive
        mkdir -p build/macos/Archive

        # Run xcodebuild to generate the archive
        xcodebuild -workspace macos/Runner.xcworkspace \
                   -scheme Runner \
                   -configuration Release \
                   -archivePath build/macos/Archive/App.xcarchive \
                   archive

        if [ -d "build/macos/Archive/App.xcarchive" ]; then
            # Zip it if you need to move it around, or leave it as is to open in Xcode
            mv build/macos/Archive/App.xcarchive outputs/
            echo -e "${YELLOW}macOS .xcarchive successfully generated in outputs/ ${BLACK}"
        else
            echo -e "${RED}macOS archive failed. Check your code signing entitlements!${BLACK}"
        fi
    else
        # Standard .app build (your existing logic)
        FILE=$(find build/macos/Build/Products/Release -maxdepth 1 -type d -name "*.app" | head -1)

        if [ -n "$FILE" ]; then
            mv "$FILE" outputs/
            echo -e "${YELLOW}macOS .app successfully moved to outputs/ ${BLACK}"
        else
            echo -e "${RED}macOS build failed or .app not found.${BLACK}"
        fi
    fi
fi