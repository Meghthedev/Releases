#!/bin/bash

# Copy zip here
gh auth login
filename=$(ls *.zip)

# Create a tag and release using the filename (without .zip extension)
version=${filename%.zip}

git tag -a "$version" -m "Release $version"

git push origin "$version"

gh release create "$version" "$filename" -t "Release $version" -n "Release notes"

