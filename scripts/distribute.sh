#!/bin/bash

cd "$(dirname -- "${BASH_SOURCE[0]}")" || exit

while getopts p:f:g: flag
do
    case "${flag}" in
        p) platform="${OPTARG}";;
        f) flavor="${OPTARG}";;
        g) distribution_groups="${OPTARG}";;
        *) ;;
    esac
done

export FASTLANE_USER="dev@digisalad.cool"
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="txst-pmbj-cssa-uelm"

# Build with app-store export method for iOS to enable TestFlight upload
if [ "$platform" == "ios" ]; then
  sh build.sh -f $flavor -p $platform -m app-store
else
  sh build.sh -f $flavor -p $platform
fi

case $flavor in
    dev)
      package_id="com.hk.lrc.dev"
      ios_id="1:406978837341:ios:1194d9fca90b391eab46b4"
      android_id="1:406978837341:android:7cd0294cf09fad10ab46b4"
      apple_team_id="S3PLWB67FE"
      asc_key_id="527N44TB2R"
      asc_issuer_id="69a6de95-991e-47e3-e053-5b8c7c11a4d1"
      asc_key_filepath="../keys/AuthKey_527N44TB2R.p8"
      ;;
    qa)
      package_id="com.hk.lrc.qa"
      ios_id="1:406978837341:ios:1194d9fca90b391eab46b4"
      android_id="1:406978837341:android:7cd0294cf09fad10ab46b4"
      apple_team_id="S3PLWB67FE"
      asc_key_id="527N44TB2R"
      asc_issuer_id="69a6de95-991e-47e3-e053-5b8c7c11a4d1"
      asc_key_filepath="../keys/AuthKey_527N44TB2R.p8"
      ;;
    uat)
      package_id="com.hk.lrc.uat"
      ios_id="1:406978837341:ios:594fdc2a9721ea50ab46b4"
      android_id="1:406978837341:android:e97e183d176e25ecab46b4"
      apple_team_id="S3PLWB67FE"
      asc_key_id="527N44TB2R"
      asc_issuer_id="69a6de95-991e-47e3-e053-5b8c7c11a4d1"
      asc_key_filepath="../keys/AuthKey_527N44TB2R.p8"
      ;;
    prod)
      package_id="com.hk.lrc"
      ios_id="1:435839766051:ios:f3aca353d622735372ab96"
      android_id="1:435839766051:android:d56bec4e770fbdb672ab96"
      apple_team_id="PUG6BWNV8Q"
      asc_key_id="XT22276HN9"
      asc_issuer_id="0b2b50cb-07a4-41a4-ade9-b12b8c354781"
      asc_key_filepath="../keys/AuthKey_XT22276HN9.p8"
      ;;
    ?)
      echo "Unknown flavor. Please check the value of -f."
      exit 1
      ;;
esac

# android
if [ "$platform" == "android" ] || [ -z "$platform" ]
then
  cd ..
  cd ./android || exit
  fastlane upload flavor:"$flavor" firebase_app_id:"$android_id" groups:"$distribution_groups"
fi

if [[ "$platform" == "ios" ]] || [ -z "$platform" ]
then
  cd ..
  cd ./ios || exit
  fastlane upload app_identifier:"$package_id" flavor:"$flavor" firebase_app_id:"$ios_id" groups:"$distribution_groups" team_id:"$apple_team_id" asc_key_id:"$asc_key_id" asc_issuer_id:"$asc_issuer_id" asc_key_filepath:"$asc_key_filepath"
fi