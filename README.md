# Countries Cities Reader

## Overview

The *Countries Cities Reader* project is a Swift library designed to provide simplified access to detailed information about the world's countries, their cities, and the flags of the countries. It integrates data from external sources and offers features for querying this data in an efficient and intuitive manner.

## Features

- **Country Data Loading**: Reading and interpreting JSON data containing information about countries, including their codes, names, and flags.
- **Flag Management**: Retrieving the paths to the flag image files of countries.
- **City Querying**: Accessing city data based on criteria such as country code and taking into account the time zone and daylight saving time for each city.
- **ShapeLib Integration**: Using ShapeLib to manipulate geographical data, allowing for advanced management of information related to cities.

## Compatibility

This project has been tested and optimized for the following devices and systems:

- iOS devices (iPhone and iPad).
- Mac computers.

## Dependencies

This project integrates several external dependencies, each under its own license:

- **ShapeLib** ([shapelib v1.6.0](https://github.com/OSGeo/shapelib/releases/tag/v1.6.0)) is used for manipulating geographical data. Included in `./Source/shapelib-1.6.0`. The configuration has been adapted from the original `Makefile` to ensure compatibility. ShapeLib is available under a dual LGPL and MIT license, and this project uses the version under the MIT license for its greater permissiveness.
    - *License*: [MIT](https://opensource.org/licenses/MIT).

- **Countries** ([mledoze/countries](https://github.com/mledoze/countries.git)) offers a comprehensive list of countries as well as the SVG files for the flags.
    - *License*: The data is under [ODbL](https://opendatacommons.org/licenses/odbl/) license.

- **Natural Earth Data** ([ne_10m_populated_places.zip](https://www.naturalearthdata.com)) provides a list of cities, used to enrich the database of localities.
    - *License*: Free for use under [public domain](https://www.naturalearthdata.com/about/terms-of-use/).

## License

This project is under the MIT License. For more details, see the [LICENSE](LICENSE) file.

## Contact

For any questions, suggestions, or feedback, feel free to contact the project maintainer at [stephane@bressani.dev](mailto:stephane@bressani.dev).
