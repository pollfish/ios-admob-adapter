// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PollfishAdMobAdapter",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "PollfishAdMobAdapter",
            targets: ["PollfishAdMobAdapter", "Wrapper"])
    ],
    dependencies: [
        .package(
            name: "GoogleMobileAds",
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            "9.0.0" ..< "10.0.0"
        ),
        .package(
            name: "Pollfish",
            url: "https://github.com/pollfish/ios-sdk-pollfish.git",
            .exact("6.4.1")
        )
    ],
    targets: [
        .target(
            name: "Wrapper",
            dependencies: ["Pollfish", "GoogleMobileAds"],
            path: "Wrapper"
        ),
        .binaryTarget(
            name: "PollfishAdMobAdapter",
            path: "PollfishAdMobAdapter.xcframework"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
