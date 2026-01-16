// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftStructure",
    platforms: [.macOS(.v26)],
    targets: [
        .executableTarget(
            name: "SwiftStructure"
        ),
        .testTarget(
            name: "SwiftStructureTests",
            dependencies: ["SwiftStructure"]
        ),
    ]
)
