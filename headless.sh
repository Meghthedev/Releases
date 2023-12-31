#!/bin/bash

# Set Github Release version name from names of file
version=$(ls *.zip | tr -d '\n')

# Check if the tag already exists
if git rev-parse "$version" &> /dev/null; then
  echo "Error: The release tag '$version' already exists."
  exit 1
fi

# Create the tag and push it to GitHub
git tag -a "$version" -m "Release $version"
git push origin "$version"

# Upload all .zip files in the current directory
filenames=(*.zip)

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