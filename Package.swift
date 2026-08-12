// swift-tools-version:6.0

import PackageDescription

extension Product.Library.LibraryType {
    static var smart: Self {
        #if os(Linux)
        return .static
        #else
        return .dynamic
        #endif
    }
}

let package = Package(
    name: "xtool-core",
    platforms: [
        .iOS("14.0"),
        .macOS("11.0"),
    ],
    products: [
        .library(
            name: "Superutils",
            type: .smart,
            targets: ["Superutils"]
        ),
        .library(
            name: "SuperutilsTestSupport",
            type: .smart,
            targets: ["SuperutilsTestSupport"]
        ),
        .library(
            name: "ProtoCodable",
            type: .smart,
            targets: ["ProtoCodable"]
        ),
        .library(
            name: "SignerSupport",
            type: .smart,
            targets: ["SignerSupport"]
        ),
        .library(name: "plist", targets: ["plist"]),
        .library(name: "libimobiledeviceGlue", targets: ["libimobiledeviceGlue"]),
        .library(name: "usbmuxd", targets: ["usbmuxd"]),
        .library(name: "libimobiledevice", targets: ["libimobiledevice"]),
        .library(name: "OpenSSL", targets: ["OpenSSL"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "ProtoCodable",
            dependencies: [
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
            ]
        ),
        .target(name: "Superutils"),
        .target(name: "SignerSupport"),
        .target(name: "SuperutilsTestSupport"),
        .testTarget(
            name: "ProtoCodableTests",
            dependencies: ["ProtoCodable", "SuperutilsTestSupport"]
        ),
    ]
)

#if os(Linux) || os(Windows) || os(Android)
package.targets += [
    .systemLibrary(
        name: "OpenSSL",
        path: "Sources/OpenSSLSystem",
        pkgConfig: "openssl",
        providers: [
            .apt(["libssl-dev"])
        ]
    ),
    .systemLibrary(
        name: "plist",
        path: "Sources/plistSystem",
        pkgConfig: "libplist-2.0",
        providers: [
            .apt(["libplist-dev"])
        ]
    ),
    .systemLibrary(
        name: "usbmuxd",
        path: "Sources/usbmuxdSystem",
        pkgConfig: "libusbmuxd-2.0",
        providers: [
            .apt(["libusbmuxd-dev"])
        ]
    ),
    .systemLibrary(
        name: "libimobiledeviceGlue",
        path: "Sources/libimobiledeviceGlueSystem",
        pkgConfig: "libimobiledevice-glue-1.0",
        providers: [
            .apt(["libimobiledevice-dev"])
        ]
    ),
    .systemLibrary(
        name: "libimobiledevice",
        path: "Sources/libimobiledeviceSystem",
        pkgConfig: "libimobiledevice-1.0",
        providers: [
            .apt(["libimobiledevice-dev"])
        ]
    ),
]
#else
package.targets += [
    .binaryTarget(
        name: "plist",
        url: "https://github.com/xtool-org/xtool-libs/releases/download/1.0.0/plist.xcframework.zip",
        checksum: "b71d1b2c86880cd2c8f353c6357c6d610849a2b461855ae782922720a0ecce3e"
    ),
    .binaryTarget(
        name: "libimobiledeviceGlue",
        url: "https://github.com/xtool-org/xtool-libs/releases/download/1.0.0/libimobiledeviceGlue.xcframework.zip",
        checksum: "227c43c1d7db213f3f75d8cdb0bba873321151ff80c2afd5217982642a2810e1"
    ),
    .binaryTarget(
        name: "usbmuxd",
        url: "https://github.com/xtool-org/xtool-libs/releases/download/1.0.0/usbmuxd.xcframework.zip",
        checksum: "9afdc82607c4339e19f31a487fe042ebee778040e805380704c5d89fb2a99081"
    ),
    .binaryTarget(
        name: "libimobiledevice",
        url: "https://github.com/xtool-org/xtool-libs/releases/download/1.0.0/libimobiledevice.xcframework.zip",
        checksum: "24c23d4ac43581e9bd6f3f198bade77d0ca928226b4a2230963162472828611f"
    ),
    .binaryTarget(
        name: "OpenSSL",
        url: "https://github.com/krzyzanowskim/OpenSSL/releases/download/3.3.2000/OpenSSL.xcframework.zip",
        checksum: "41d034ea1c075bfa74048e851358a550996c286de8230d1df39f137b06235c87"
    ),
]
#endif
