#!/bin/bash
cd "$(dirname -- "${BASH_SOURCE[0]}")" || exit

YELLOW='\033[1;33m'
RED='\033[1;31m'
BLACK='\033[0;30m'

while getopts p: flag
do
    case "${flag}" in
        p) platform="${OPTARG}";;
        *) ;;
    esac
done

# shellcheck disable=SC2091
yes Y | $(rm -r ../outputs)
mkdir -p ../outputs;


# android
if [ "$platform" == "android" ] || [ -z "$platform" ]
then
  cd ../
  flutter build appbundle --split-debug-info --obfuscate -t "lib/view/main.dart" --flavor="prod" --release
fi

if [ "$platform" == "ios" ] || [ -z "$platform" ]
then
   # ios
    flutter build ipa --obfuscate --split-debug-info -t "lib/view/main.dart" --flavor="prod" --release
    cd ..
    cd ./ios || exit
    fastlane deploy
fi
