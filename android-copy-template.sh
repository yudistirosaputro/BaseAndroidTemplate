#!/bin/bash

# Function to convert Windows path to WSL format
convert_to_wsl_path() {
  local path=$1
  # Replace backslashes with slashes
  path=$(echo "$path" | sed 's/\\/\//g')
  
  # Convert drive letter (C: -> /mnt/c)
  drive=$(echo "$path" | grep -o '^[A-Za-z]:' | cut -d: -f1 | tr '[:upper:]' '[:lower:]')

  # If drive is found, replace path according to WSL format
  if [[ -n "$drive" ]]; then
    echo "/mnt/$drive/${path#*:}"
  else
    # If no drive is found, return the path directly (for Unix-based systems)
    echo "$path"
  fi
}
# Check if the number of arguments is sufficient
if [ $# -lt 3 ]; then
  echo "Usage: ./android-copy-template.sh <target-folder> <package-name> <project-name>"
  exit 1
fi

TARGET_FOLDER=$1
PACKAGE_NAME=$2
PROJECT_NAME=$3

echo "Target folder: $TARGET_FOLDER"
# Convert destination folder to WSL format if given in Windows format
TARGET_FOLDER_WSL=$(convert_to_wsl_path "$TARGET_FOLDER")

# Determine template folder and destination folder
SOURCE_FOLDER=$(pwd)  # Current template folder
DESTINATION_FOLDER="$TARGET_FOLDER_WSL"

# Display status
echo "Copying contents from $SOURCE_FOLDER to $DESTINATION_FOLDER"

# Create destination folder if it doesn't exist
mkdir -p "$DESTINATION_FOLDER"

# Copy folder contents, excluding files or folders that should be excluded
rsync -av  --exclude='android-copy-template.sh' --exclude='.gradle' --exclude='.idea' --exclude='.gitignore' --exclude='local.properties' --exclude='build/' --exclude='.git' "$SOURCE_FOLDER/" "$DESTINATION_FOLDER/"

# Replace package name, namespace, and applicationID in build.gradle
echo "Changing package name, namespace, and applicationID in build.gradle..."

# Check if build.gradle file exists before running sed command
BUILD_GRADLE="$DESTINATION_FOLDER/app/build.gradle.kts"
if [ -f "$BUILD_GRADLE" ]; then
  # Adjust for system (macOS vs Linux)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/applicationId = .*/applicationId = \"$PACKAGE_NAME\"/" "$BUILD_GRADLE"
    sed -i '' "s/namespace = .*/namespace = \"$PACKAGE_NAME\"/" "$BUILD_GRADLE"
  else
    sed -i "s/applicationId = .*/applicationId = \"$PACKAGE_NAME\"/" "$BUILD_GRADLE"
    sed -i "s/namespace = .*/namespace = \"$PACKAGE_NAME\"/" "$BUILD_GRADLE"
  fi
  echo "applicationId and namespace have been changed to: $PACKAGE_NAME"
else
  echo "build.gradle file not found!"
  exit 1
fi

# Replace package name in AndroidManifest.xml file
ANDROID_MANIFEST="$DESTINATION_FOLDER/app/src/main/AndroidManifest.xml"
if [ -f "$ANDROID_MANIFEST" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # No need to change package in AndroidManifest.xml as it's handled by namespace in build.gradle.kts
    # However, we need to change references to the old package if any
    sed -i '' "s/com\.blank\.basetemplate/$PACKAGE_NAME/g" "$ANDROID_MANIFEST"
  else
    # No need to change package in AndroidManifest.xml as it's handled by namespace in build.gradle.kts
    # However, we need to change references to the old package if any
    sed -i "s/com\.blank\.basetemplate/$PACKAGE_NAME/g" "$ANDROID_MANIFEST"
  fi
  echo "Package references in AndroidManifest.xml have been changed to: $PACKAGE_NAME"
else
  echo "AndroidManifest.xml file not found!"
  exit 1
fi

# Change project name in settings.gradle
SETTINGS_GRADLE="$DESTINATION_FOLDER/settings.gradle.kts"
if [ -f "$SETTINGS_GRADLE" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/rootProject.name = \".*\"/rootProject.name = \"$PROJECT_NAME\"/" "$SETTINGS_GRADLE"
  else
    sed -i "s/rootProject.name = \".*\"/rootProject.name = \"$PROJECT_NAME\"/" "$SETTINGS_GRADLE"
  fi
  echo "Project name has been changed to: $PROJECT_NAME"
else
  echo "settings.gradle file not found!"
  exit 1
fi

# Change package folder structure
echo "Changing package folder structure..."

# Get java folder paths for main, test, and androidTest
MAIN_JAVA_DIR="$DESTINATION_FOLDER/app/src/main/java"
TEST_JAVA_DIR="$DESTINATION_FOLDER/app/src/test/java"
ANDROID_TEST_JAVA_DIR="$DESTINATION_FOLDER/app/src/androidTest/java"

# Get package path from package name (com.example.app -> com/example/app)
OLD_PACKAGE_PATH="com/blank/basetemplate"
NEW_PACKAGE_PATH=$(echo "$PACKAGE_NAME" | sed 's/\./\//g')

# Create new directories for package in all locations
mkdir -p "$MAIN_JAVA_DIR/$NEW_PACKAGE_PATH"
mkdir -p "$TEST_JAVA_DIR/$NEW_PACKAGE_PATH"
mkdir -p "$ANDROID_TEST_JAVA_DIR/$NEW_PACKAGE_PATH"

# Function to process java folders
process_java_folder() {
  local JAVA_DIR=$1
  
  # Move all files from old package to new package
  if [ -d "$JAVA_DIR/$OLD_PACKAGE_PATH" ]; then
    # Copy all files from old package to new package
    cp -r "$JAVA_DIR/$OLD_PACKAGE_PATH/"* "$JAVA_DIR/$NEW_PACKAGE_PATH/"
  
    # Replace package name in all .kt and .java files
    if [[ "$OSTYPE" == "darwin"* ]]; then
      find "$JAVA_DIR/$NEW_PACKAGE_PATH" -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i '' "s/package com.blank.basetemplate/package $PACKAGE_NAME/g" {} \;
      find "$JAVA_DIR/$NEW_PACKAGE_PATH" -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i '' "s/import com.blank.basetemplate/import $PACKAGE_NAME/g" {} \;
      # Replace package references in assertions and other code
      find "$JAVA_DIR/$NEW_PACKAGE_PATH" -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i '' "s/com.blank.basetemplate/$PACKAGE_NAME/g" {} \;
    else
      find "$JAVA_DIR/$NEW_PACKAGE_PATH" -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i "s/package com.blank.basetemplate/package $PACKAGE_NAME/g" {} \;
      find "$JAVA_DIR/$NEW_PACKAGE_PATH" -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i "s/import com.blank.basetemplate/import $PACKAGE_NAME/g" {} \;
      # Replace package references in assertions and other code
      find "$JAVA_DIR/$NEW_PACKAGE_PATH" -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i "s/com.blank.basetemplate/$PACKAGE_NAME/g" {} \;
    fi
  
  # Replace package name in XML files
  XML_FILES=$(find "$DESTINATION_FOLDER" -type f -name "*.xml")
  for XML_FILE in $XML_FILES; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s/com\.blank\.basetemplate/$PACKAGE_NAME/g" "$XML_FILE"
    else
      sed -i "s/com\.blank\.basetemplate/$PACKAGE_NAME/g" "$XML_FILE"
    fi
  done
  
  # Replace references in resource files
  THEME_FILES=$(find "$DESTINATION_FOLDER/app/src/main/res/values" -type f -name "*.xml")
  for THEME_FILE in $THEME_FILES; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s/BaseTemplate/$PROJECT_NAME/g" "$THEME_FILE"
    else
      sed -i "s/BaseTemplate/$PROJECT_NAME/g" "$THEME_FILE"
    fi
  done
  
    # Intelligently delete old directories, only removing folders that are no longer used
    if [ "$OLD_PACKAGE_PATH" != "$NEW_PACKAGE_PATH" ]; then
      # Split old and new paths into arrays
      IFS='/' read -ra OLD_PARTS <<< "$OLD_PACKAGE_PATH"
      IFS='/' read -ra NEW_PARTS <<< "$NEW_PACKAGE_PATH"
      
      # Determine the highest level folder that differs
      DIFFERENT_LEVEL=0
      MAX_CHECK=$((${#OLD_PARTS[@]} < ${#NEW_PARTS[@]} ? ${#OLD_PARTS[@]} : ${#NEW_PARTS[@]}))
      
      for ((i=0; i<MAX_CHECK; i++)); do
        if [ "${OLD_PARTS[$i]}" != "${NEW_PARTS[$i]}" ]; then
          DIFFERENT_LEVEL=$i
          break
        fi
        # If all checked parts are the same, the difference is at the next level
        if [ $i -eq $((MAX_CHECK-1)) ]; then
          DIFFERENT_LEVEL=$MAX_CHECK
        fi
      done
      
      # Create path for folders that need to be deleted
      if [ $DIFFERENT_LEVEL -lt ${#OLD_PARTS[@]} ]; then
        DELETE_PATH=""
        for ((i=0; i<DIFFERENT_LEVEL; i++)); do
          DELETE_PATH="$DELETE_PATH/${OLD_PARTS[$i]}"
        done
        DELETE_PATH="${DELETE_PATH#/}/${OLD_PARTS[$DIFFERENT_LEVEL]}"
        
        echo "Deleting unused folder in $JAVA_DIR: $DELETE_PATH"
        rm -rf "$JAVA_DIR/$DELETE_PATH"
      fi
    fi
    
    echo "Package folder structure in $JAVA_DIR has been changed from $OLD_PACKAGE_PATH to $NEW_PACKAGE_PATH"
  else
    echo "Old package folder not found in: $JAVA_DIR/$OLD_PACKAGE_PATH"
  fi
}
# Process all java folders
process_java_folder "$MAIN_JAVA_DIR"
process_java_folder "$TEST_JAVA_DIR"
process_java_folder "$ANDROID_TEST_JAVA_DIR"

# Search for old package folders outside the app folder
echo "Searching for old package folders outside the app folder..."
OUTSIDE_JAVA_DIRS=$(find "$DESTINATION_FOLDER" -type d -path "*/java/com/blank/basetemplate" | grep -v "$DESTINATION_FOLDER/app/")

for OUTSIDE_DIR in $OUTSIDE_JAVA_DIRS; do
  # Get java folder path from full path
  OUTSIDE_JAVA_BASE_DIR=$(echo "$OUTSIDE_DIR" | sed 's|/com/blank/basetemplate||')
  echo "Found old package folder in: $OUTSIDE_JAVA_BASE_DIR"
  process_java_folder "$OUTSIDE_JAVA_BASE_DIR"
done