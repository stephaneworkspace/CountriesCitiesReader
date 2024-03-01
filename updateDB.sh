#!/bin/bash
#
# Created by Stéphane Bressani on 29.02.2024.
#
# This shell code:
#
# -> Update ./Source/Resources/res/flags.zip
#    with data from https://github.com/mledoze/countries.git
#    and convert svg to png
# -> Update ./Source/Resources/res/mledoze-countries.zip
#    with data from https://github.com/mledoze/countries.git
# -> Update ./Source/Resources/res/ne_10m_populated_places.zip
#    with data from https://www.naturalearthdata.com
#
# Need: brew install cairo
#       brew install librsvg

# Delete resources
rm ./Source/Resources/res/flags.zip
rm ./Source/Resources/res/mledoze-countries.zip
rm ./Source/Resources/res/ne_10m_populated_places.zip

# News resources
if [ -d ./tmp ]; then
    rm -rf ./tmp
fi
mkdir tmp
cd ./tmp
if [ -d ./countries ]; then
    rm -rf ./countries
fi
git clone https://github.com/mledoze/countries.git
cd ./countries
rm -rf .git
cd ..

mkdir -p ./out
cd ..
./scripts/convert_svg_to_png.sh ./tmp/countries/data/ ./tmp/out/ 50 50
(cd ./tmp/out && zip -r ../../Source/Resources/res/flags.zip .)
cd tmp
rm -rf ./out
(cd ./countries && zip -r ../../Source/Resources/res/mledoze-countries.zip countries.json)
rm -rf ./countries
curl -o ne_10m_populated_places.zip https://naciscdn.org/naturalearth/10m/cultural/ne_10m_populated_places.zip
cp ne_10m_populated_places.zip ../Source/Resources/res/ne_10m_populated_places.zip
cd ..
rm -rf ./tmp
