#!/bin/bash
#
# Created by Stéphane Bressani on 29.02.2024.
#
# svg to png
# need: brew install cairo
#       brew install librsvg

# Check number of arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <source_directory> <destination_directory> <size>"
    exit 1
fi

SOURCE_DIR=$1
DEST_DIR=$2
SIZEW=$3
SIZEH=$4

# Create dir if not exist
mkdir -p "$DEST_DIR"

# Convert SVG to PNG3
for svg_file in "$SOURCE_DIR"/*.svg; do
    filename=$(basename -- "$svg_file")
    filename="${filename%.*}"
    png_file="$DEST_DIR/$filename.png"
    rsvg-convert "$svg_file" -o "$png_file" -w "$SIZEW" -h "$SIZEH"
done

echo "Conversion finished."
