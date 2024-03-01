// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "CountriesCitiesReader",
        platforms: [
            .iOS("17.2"),
            .macOS("14.2")
        ],
        products: [
            .library(name: "CountriesCitiesReader", targets: ["CountriesCitiesReader"]),
        ],
        dependencies: [
            .package(url: "https://github.com/marmelroy/Zip", from: "2.1.2"),
        ],
        targets: [
            .target(name: "Unzip", dependencies: ["Zip"]),
            .target(name: "Resources", 
                    dependencies: ["Unzip"],
                    resources: [.process("res")]),
            .target(name: "Countries",
                    dependencies: []),
            .target(name: "Cities",
                    dependencies: []),
            .target(name: "shapelib-1.6.0", publicHeadersPath: "./"),
            .target(name: "cwrapper", dependencies: ["shapelib-1.6.0"]),
            .target(name: "CountriesCitiesReader",
                    dependencies: ["Resources", "Countries", "Cities", "cwrapper"]),
        ]
)
