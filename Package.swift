// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "EditorJSKit",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "EditorJSKit",
            targets: ["EditorJSKit"]
        ),
    ],

    targets: [
        .target(
            name: "EditorJSKit",
            path: "EditorJSKit"
        )
    ]
)
