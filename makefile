
update-all:
	make update-icon
	make update-image
	make update-string

update-image:
	sh scripts/updateImages.sh

update-string:
	sh scripts/updateString.sh

update-icon:
	sh scripts/updateIcons.sh

# build-ios-uat
# 	flutter run --release -t lib/view/main_uat.dart --flavor uat

# build-android-uat
# 	sh scripts/build.sh -p android -f uat -m apk  






