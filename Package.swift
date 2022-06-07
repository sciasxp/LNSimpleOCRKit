// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LNSimpleOCRKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LNSimpleOCRKit",
            targets: ["LNSimpleOCRKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LNSimpleOCRKit",
            dependencies: [],
            swiftSettings: [
                .define(
                    "EXCLUDED_ARCHS[sdk=iphonesimulator*]='arm64'",
                    .when(platforms: [.iOS], configuration: .debug)
                )
            ]
        ),
        .testTarget(
            name: "LNSimpleOCRKitTests",
            dependencies: ["LNSimpleOCRKit"],
            resources: [.process("Assets")]),
    ],
    swiftLanguageVersions: [.v5]
)

let version = Version("1.0.0")
