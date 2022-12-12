// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HttpClient",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
	],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HttpClient",
            targets: ["HttpClient"]),
		.library(
			name: "HttpClientUtilities",
			targets: ["HttpClientUtilities"]),
		.library(
			name: "URLEncodedForm",
			targets: ["URLEncodedForm"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HttpClient",
            dependencies: ["HttpClientUtilities", "URLEncodedForm"]),
		.target(
			name: "HttpClientUtilities",
			dependencies: ["URLEncodedForm"]),
		.target(
			name: "URLEncodedForm",
			dependencies: []),
        .testTarget(
            name: "HttpClientTests",
            dependencies: ["HttpClient"]),
    ]
)
