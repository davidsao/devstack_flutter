#!/bin/bash

source $(dirname $0)/config.sh

set -e # Exit on first failed command

# Variables
TARGET_PATH="$RESOURCE_PATH/icons"
OUTPUT_PATH="$GENERATED_PATH"

# Colors for echo
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

# Create directory for output if it doesn't exist yet
if [ ! -d "$OUTPUT_PATH" ]
then
    mkdir "$OUTPUT_PATH"
fi

# Create directory for output if it doesn't exist yet
if [ ! -d "$TARGET_PATH" ]
then
    mkdir "$TARGET_PATH"
fi

echo "${GREEN}Updating icons references..."

echo "${YELLOW}Reading icon files..."
content=""
for d in $TARGET_PATH/* ; do
  fileName=$(basename "$d")

  # extract the file name
  # icon_nav_home.svg -> home
  replace=""
  newFileName="${fileName//".svg"/$replace}"
  newFileName="${newFileName//"icon_"/$replace}"

  # variable name of the icon
  # convert to camel case
  iconName=$(echo "$newFileName" | awk -F _ '{printf "%s", $1; for(i=2; i<=NF; i++) printf "%s", toupper(substr($i,1,1)) substr($i,2); print"";}')
  # append to main content of the file
  content="${content}\n\tstatic String $iconName = \"\$_path/$fileName\";"
done

# write content to the file
result="class IconKeys {\n\n\tstatic const String _path = \"${TARGET_PATH}\";\n${content}\n}"
echo "$result" > "${OUTPUT_PATH}/"icon_keys.g.dart
echo "${GREEN}All done! File generated in ${OUTPUT_PATH}/icon_keys.g.dart"
echo "${GREEN}Update icons references success!"

