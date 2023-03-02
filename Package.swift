// swift-tools-version: 5.7

import PackageDescription

let package = Package(name: "DcaltLib",
                      platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9)],
                      products: [
                          .library(name: "DcaltLib",
                                   targets: ["DcaltLib"]),
                      ],
                      dependencies: [
                        .package(url: "https://github.com/open-trackers/TrackerLib.git", from: "1.0.0"),
                      ],
                      targets: [
                          .target(name: "DcaltLib",
                                  dependencies: [
                                      .product(name: "TrackerLib", package: "TrackerLib"),
                                  ],
                                  path: "Sources",
                                  resources: [
                                      .process("Resources"),
                                  ]),
                          .testTarget(name: "DcaltLibTests",
                                      dependencies: [
                                          "DcaltLib",
                                          .product(name: "TrackerLib", package: "TrackerLib"),
                                      ],
                                      path: "Tests"),
                      ])
