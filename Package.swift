// swift-tools-version: 5.7

import PackageDescription

let package = Package(name: "DcaltLib",
                      platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9)],
                      products: [
                          .library(name: "DcaltLib",
                                   targets: ["DcaltLib"]),
                      ],
                      dependencies: [
                          // .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.4"),
                          .package(name: "TrackerLib", path: "../TrackerLib"),
                          // .package(name: "ColorThemeLib", path: "../ColorThemeLib"),
                      ],
                      targets: [
                          .target(name: "DcaltLib",
                                  dependencies: [
                                      .product(name: "TrackerLib", package: "TrackerLib"),
                                      // .product(name: "ColorThemeLib", package: "ColorThemeLib"),
                                      // .product(name: "Collections", package: "swift-collections"),
                                  ],
                                  path: "Sources",
                                  resources: [
                                      .process("Resources"),
                                  ]),
                          .testTarget(name: "DcaltLibTests",
                                      dependencies: [
                                          "DcaltLib",
                                          .product(name: "TrackerLib", package: "TrackerLib"),
                                          // .product(name: "ColorThemeLib", package: "ColorThemeLib"),
                                      ],
                                      path: "Tests"),
                      ])
