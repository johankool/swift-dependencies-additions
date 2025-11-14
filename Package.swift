// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

///
/// - `DependenciesAdditions`: All non-experimental dependencies;
/// - `DependenciesAdditionsBasics`: Only utilities and direct extensions to `swift-dependencies`.
///
/// - `AccessibilityDependency`:       `\.accessibility`
/// - `ApplicationDependency`:         `\.application`
/// - `BundleDependency`:              `\.bundleInfo`
/// - `CodableDependency`:             `\.encode` and `\.decode`
/// - `CompressionDependency`:         `\.compress` and `\.decompress`
/// - `DataDependency`:                `\.dataReader` and `\.dataWriter`
/// - `DeviceDependency`:              `\.device` and `\.deviceCheckDevice`
/// - `LoggerDependency`:              `\.logger`
/// - `NotificationCenterDependency`:  `\.notificationCenter`
/// - `PathDependency`:                `\.path`
/// - `PersistentContainerDependency`: `\.persitentContainer`
/// - `ProcessInfoDependency`:         `\.processInfo`
/// - `UserDefaultsDependency`:        `\.userDefaults`
/// - `UserNotificationsDependency`:   `\.userNotificationCenter`
///
/// - `_AppStorageDependency`:         `@Dependency.AppStorage` property wrapper
/// - `_NotificationDependency`:       `@Dependency.Notification` property wrapper
/// - `_CoreDataDependency`:            wip
/// - `_SwiftUIDependency`:            `@Dependency.Environment` property wrapper

let package = Package(
  name: "swift-dependencies-additions",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "DependenciesAdditions", targets: ["DependenciesAdditions"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.5"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.2.3"),
  ],
  targets: [

    .target(
      name: "DependenciesAdditions",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        "LoggerDependency",
        "UserDefaultsDependency",
      ]
    ),

    .target(
      name: "DependenciesAdditionsBasics",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
      ]
    ),

    .testTarget(
      name: "DependenciesAdditionsBasicsTests",
      dependencies: [
        .product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
        "DependenciesAdditionsBasics",
      ]
    ),

    .target(
      name: "LoggerDependency",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
//        "BundleDependency",
      ]
    ),

    .testTarget(
      name: "LoggerDependencyTests",
      dependencies: [
        "LoggerDependency"
      ]
    ),

    .target(
      name: "UserDefaultsDependency",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        "DependenciesAdditionsBasics",
      ]
    ),

    .testTarget(
      name: "UserDefaultsDependencyTests",
      dependencies: [
        "UserDefaultsDependency"
      ]
    ),
  ]
)

/// Temporary dependencies
// define("CryptoDependency")
// define("KeyChainDependency")
// define("Version")?

// define("Dependency", dependencies: "Base", testingDependencies: "TestSupport")
func define(_ target: String, dependencies: String..., testingDependencies: String...) {
  var targetDependencies: [Target.Dependency] = [
    .product(name: "Dependencies", package: "swift-dependencies")
  ]
  for dependency in dependencies {
    targetDependencies.append(.target(name: dependency))
  }
  package.targets.append(
    .target(
      name: target, dependencies: targetDependencies
    )
  )
  var targetTestingDependencies: [Target.Dependency] = [
    .target(name: target)
  ]
  for dependency in testingDependencies {
    targetTestingDependencies.append(.target(name: dependency))
  }
  package.targets.append(
    .testTarget(name: "\(target)Tests", dependencies: targetTestingDependencies)
  )
  package.products.append(.library(name: target, targets: [target]))
}

func addIndividualProducts() {
  package.products.append(contentsOf: [
    .library(name: "DependenciesAdditionsBasics", targets: ["DependenciesAdditionsBasics"]),
    .library(name: "LoggerDependency", targets: ["LoggerDependency"]),
    .library(name: "UserDefaultsDependency", targets: ["UserDefaultsDependency"]),
  ])
}
//addIndividualProducts()

//for target in package.targets {
//  target.swiftSettings = target.swiftSettings ?? []
//  target.swiftSettings?.append(
//    .unsafeFlags([
//      "-Xfrontend", "-warn-concurrency",
//      "-Xfrontend", "-enable-actor-data-race-checks",
//      //      "-enable-library-evolution",
//    ])
//  )
//}
