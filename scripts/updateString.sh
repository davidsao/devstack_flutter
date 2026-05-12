#!/bin/bash

source $(dirname $0)/config.sh

set -e # Exit on first failed command

# Variables
OUTPUT_PATH=$RESOURCE_PATH/strings

# Colors for echo
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

# Create directory for output if it doesn't exist yet
if [ ! -d $OUTPUT_PATH ]
then
    mkdir $OUTPUT_PATH
fi

echo "${GREEN}Updating localization..."

# Export translations from Loco

filename="translated.zip"
curl -L -o $OUTPUT_PATH/$filename "https://drive.google.com/uc?export=download&id=$GOOGLE_DRIVE_ZIP_FILE_ID"
unzip -o -qq $OUTPUT_PATH/$filename -d $OUTPUT_PATH
rm $OUTPUT_PATH/$filename
#
# Converting locale files
echo "${YELLOW}Generating locale keys..."
dart run easy_localization:generate -S $OUTPUT_PATH
dart run easy_localization:generate -S $OUTPUT_PATH -f keys -o locale_keys.g.dart
echo "${GREEN}Update localization success!"

