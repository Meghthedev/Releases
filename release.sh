#!/bin/bash

# Clone releases repo ( replace with your own repo obv)
git clone https://github.com/Meghthedev/Releases Releases

cd Releases

# run gh auth login once

# Now, ask user for path to the rom file
read -p "Enter the path to the ROM zip file: " rom_path
cp "${rom_path}" . 

filename=$(ls *.zip)

# Create a tag and release using the filename (without .zip extension)
version=${filename%.zip}

git tag -a "$version" -m "Release $version"

git push origin "$version"

gh release create "$version" "$filename" -t "Release $version" -n "Release notes"

# Clean up
cd ..
rm -rf Releases
