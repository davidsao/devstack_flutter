#!/bin/bash

cd "$(dirname -- "${BASH_SOURCE[0]}")" || exit

YELLOW='\033[1;33m'
RED='\033[1;31m'
BLACK='\033[0;30m'

while getopts p:f:m: flag
do
    case "${flag}" in
        p) platform="${OPTARG}";;
        f) flavor="${OPTARG}";;
        m) method="${OPTARG}";;
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
  output=$method;
  if [ -z "$method" ]
  then
    output="apk" # or appbundle
  fi
  target="lib/main_$flavor.dart"
  if [ $flavor == "prod" ]
  then
    target="lib/main.dart"
  fi
  flutter build $output --split-debug-info --obfuscate -t $target --flavor="$flavor" --release
  if [ $output == "apk" ]
  then
     FILE=$(find build/app/outputs/flutter-apk \( -name "*.apk" \))
     mv "$FILE" outputs/
  else
    FILE=$(find build/app/outputs/bundle/release \( -name "*.aab" \))
    mv "$FILE" outputs/
  fi
fi

if [ "$platform" == "ios" ] || [ -z "$platform" ]
then
   # ios
    output=$method;
    if [ -z "$method" ]
     then
       output="development"
     fi
    target="lib/main_$flavor.dart"
     if [ $flavor == "prod" ]
     then
       target="lib/main.dart"
     fi
    flutter build ipa --obfuscate --split-debug-info -t $target --flavor="$flavor" --release --export-method $output
    FILE=$(ls ../build/ios/ipa/*.ipa| head -1)
    mv "$FILE" ../outputs/"$flavor.ipa"
fi