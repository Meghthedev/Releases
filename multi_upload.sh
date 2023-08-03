#!/bin/bash

# Check if gh command-line tool is installed
if ! command -v gh &> /dev/null; then
  echo "Error: GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/ and try again."
  exit 1
fi

# Ensure the user is authenticated with GitHub
gh auth login

# Ask for the release tag name
read -p "Enter the release tag name: " version

# Check if the tag already exists
if git rev-parse "$version" &> /dev/null; then
  echo "Error: The release tag '$version' already exists."
  exit 1
fi

# Create the tag and push it to GitHub
git tag -a "$version" -m "Release $version"
git push origin "$version"

# Ask the user if they want to upload all .zip files or provide filenames
read -p "Do you want to upload all .zip files in the current directory? (y/n): " upload_all

# Initialize an array to store the filenames
declare -a filenames

if [[ "$upload_all" =~ ^[Yy]$ ]]; then
  # Upload all .zip files in the current directory
  filenames=(*.zip)
else
  # Ask the user to input the filenames
  read -p "Enter the filenames (separated by spaces): " -a filenames
fi

# Create the release on GitHub
if ! gh release create "$version" --title "Release $version" --notes "Release notes"; then
  echo "Error: Failed to create the release."
  exit 1
fi

# Upload the files to the release
for filename in "${filenames[@]}"; do
  gh release upload "$version" "$filename" --clobber
done

# Display success message
echo "Files uploaded successfully."
