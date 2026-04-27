// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SVGAPlayer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SVGAPlayer",
            targets: ["SVGAPlayer"]
        )
    ],
    targets: [
        .target(
            name: "Protobuf",
            path: "Vendor/ProtobufObjectiveC",
            exclude: [
                "generate_well_known_types.sh",
                "google"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .unsafeFlags(["-fno-objc-arc"])
            ]
        ),
        .target(
            name: "ZipArchive",
            path: "Vendor/ZipArchive",
            publicHeadersPath: "include",
            cSettings: [
                .define("HAVE_ARC4RANDOM_BUF"),
                .define("HAVE_ICONV"),
                .define("HAVE_INTTYPES_H"),
                .define("HAVE_PKCRYPT"),
                .define("HAVE_STDINT_H"),
                .define("HAVE_WZAES"),
                .define("HAVE_ZLIB"),
                .define("ZLIB_COMPAT"),
                .headerSearchPath("."),
                .headerSearchPath("minizip")
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("iconv"),
                .linkedFramework("Security")
            ]
        ),
        .target(
            name: "SVGAPBObjC",
            dependencies: [
                "Protobuf"
            ],
            path: "Source/pbobjc",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .unsafeFlags(["-fno-objc-arc"])
            ]
        ),
        .target(
            name: "SVGAPlayer",
            dependencies: [
                "SVGAPBObjC",
                "ZipArchive"
            ],
            path: "Source",
            exclude: [
                "pbobjc"
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("pbobjc"),
                .headerSearchPath("../Vendor/ZipArchive"),
                .headerSearchPath("../Vendor/ProtobufObjectiveC")
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedLibrary("z")
            ]
        )
    ]
)
