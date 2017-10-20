// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GLSceneLib",
    products: [
        .library(
            name: "GLSceneLib",
            targets: ["GLSceneLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/omochi/DebugReflect.git", from: "0.3.5")
    ],
    targets: [
        .target(
            name: "GLSceneLib",
            dependencies: ["DebugReflect"]),
        .testTarget(
            name: "GLSceneLibTests",
            dependencies: ["GLSceneLib"]),
    ]
)
