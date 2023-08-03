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

# Create the release on GitHub
if ! gh release create "$version" -t "Release $version" -n "Release notes"; then
  echo "Error: Failed to create the release."
  exit 1
fi

# Check if the user wants to upload all .zip files in the current directory
read -p "Do you want to upload all .zip files in the current directory? (y/n): " upload_all

# Upload the files to the release
if [[ "$upload_all" =~ ^[Yy]$ ]]; then
  gh release upload "$version" *.zip --clobber
else
  # Ask the user to input the filenames
  read -p "Enter the filenames (separated by spaces): " -a filenames
  for filename in "${filenames[@]}"; do
    gh release upload "$version" "$filename" --clobber
  done
fi

# Display success message
echo "Files uploaded successfully."
