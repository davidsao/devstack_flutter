echo "Update fastlane configuration"
# Android Fastlane setup
cd android/
fastlane init
fastlane add_plugin firebase_app_distribution

# Rewrite the default Fastfile with the custom Fastfile
rm fastlane/Fastfile
cp ../scripts/fastlane/AndroidFastfile fastlane/Fastfile

# IOS Fastlane setup
cd ../ios/
fastlane init
fastlane add_plugin firebase_app_distribution

# Rewrite the default Fastfile with the custom Fastfile
rm fastlane/Fastfile
cp ../scripts/fastlane/iOSFastfile fastlane/Fastfile
sed -i '' "s/app_identifier: \"com.digisalad.template\"/app_identifier: \"$NEW_BUNDLE_ID\"/" fastlane/Fastfile

# Finally remove ios and android fastlane folder under scripts
rm -rf ../scripts/fastlane