#!/bin/bash

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

# shellcheck disable=SC2091
yes Y | $(rm -r ../outputs)
mkdir -p ../outputs;

yes Y | $(rm -r ../build/app/outputs)
mkdir -p ../build/app/outputs;

yes Y | $(rm -r ../build/ios/ipa)
mkdir -p ../build/ios/ipa;

# android
if [ "$platform" == "android" ] || [ -z "$platform" ]
then
  cd ../
  target="lib/main.dart"
  output=$method;
  if [ -z "$method" ]
  then
    output="apk" # or appbundle
  fi
  flutter build $output --split-debug-info --obfuscate -t $target --release --no-tree-shake-icons
  if [ $output == "apk" ]
  then
     FILE=$(find build/app/outputs/flutter-apk \( -name "app-release.apk" \))
     mv "$FILE" outputs/
  else
    FILE=$(find build/app/outputs/bundle/release \( -name "*.aab" \))
    mv "$FILE" outputs/
  fi
fi

if [ "$platform" == "ios" ] || [ -z "$platform" ]
then
    output=$method;
    if [ -z "$method" ]
     then
       output="development"
     fi
    target="lib/main.dart"
           prefix=""
    flutter build ipa --obfuscate --split-debug-info -t $target --release --export-method $output
    FILE=$(ls ../build/ios/ipa/*.ipa| head -1)
    mv "$FILE" ../outputs/"app.ipa"
fi