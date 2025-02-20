/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2018 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
 */

extension Package.Dependency {
    /// An enum that represents the requirement for a package dependency.
    ///
    /// The dependency requirement can be defined as one of three different version requirements:
    ///
    /// **A version-based requirement.**
    ///
    /// Decide whether your project accepts updates to a package dependency up
    /// to the next major version or up to the next minor version. To be more
    /// restrictive, select a specific version range or an exact version.
    /// Major versions tend to have more significant changes than minor
    /// versions, and may require you to modify your code when they update.
    /// The version rule requires Swift packages to conform to semantic
    /// versioning. To learn more about the semantic versioning standard,
    /// visit [semver.org](https://semver.org).
    ///
    /// Selecting the version requirement is the recommended way to add a package dependency. It allows you to create a balance between restricting changes and obtaining improvements and features.
    ///
    /// **A branch-based requirement**
    ///
    /// Select the name of the branch for your package dependency to follow.
    /// Use branch-based dependencies when you're developing multiple packages
    /// in tandem or when you don't want to publish versions of your package dependencies.
    ///
    /// Note that packages which use branch-based dependency requirements
    /// can't be added as dependencies to packages that use version-based dependency
    /// requirements; you should remove branch-based dependency requirements
    /// before publishing a version of your package.
    ///
    /// **A commit-based requirement**
    ///
    /// Select the commit hash for your package dependency to follow.
    /// Choosing this option isn't recommended, and should be limited to
    /// exceptional cases. While pinning your package dependency to a specific
    /// commit ensures that the package dependency doesn't change and your
    /// code remains stable, you don't receive any updates at all. If you worry about
    /// the stability of a remote package, consider one of the more
    /// restrictive options of the version-based requirement.
    ///
    /// Note that packages which use commit-based dependency requirements
    /// can't be added as dependencies to packages that use version-based
    /// dependency requirements; you should remove commit-based dependency
    /// requirements before publishing a version of your package.
    @available(_PackageDescription, deprecated: 5.6)
    public enum Requirement {
        case exactItem(Version)
        case rangeItem(Range<Version>)
        case revisionItem(String)
        case branchItem(String)
        case localPackageItem

        var isLocalPackage: Bool {
            if case .localPackageItem = self { return true }
            return false
        }
    }
}

@available(_PackageDescription, deprecated: 5.6)
extension Package.Dependency.Requirement {
    /// Returns a requirement for the given exact version.
    ///
    /// Specifying exact version requirements are not recommended as
    /// they can cause conflicts in your dependency graph when multiple other packages depend on a package.
    /// As Swift packages follow the semantic versioning convention,
    /// think about specifying a version range instead.
    ///
    /// The following example defines a version requirement that requires version 1.2.3 of a package.
    ///
    ///   .exact("1.2.3")
    ///
    /// - Parameters:
    ///      - version: The exact version of the dependency for this requirement.
    @available(_PackageDescription, deprecated: 5.6)
    public static func exact(_ version: Version) -> Package.Dependency.Requirement {
        return .exactItem(version)
    }

    /// Returns a requirement for a source control revision such as the hash of a commit.
    ///
    /// Note that packages that use commit-based dependency requirements
    /// can't be depended upon by packages that use version-based dependency
    /// requirements; you should remove commit-based dependency requirements
    /// before publishing a version of your package.
    ///
    /// The following example defines a version requirement for a specific commit hash.
    ///
    ///   .revision("e74b07278b926c9ec6f9643455ea00d1ce04a021")
    ///
    /// - Parameters:
    ///     - ref: The Git revision, usually a commit hash.
    @available(_PackageDescription, deprecated: 5.6)
    public static func revision(_ ref: String) -> Package.Dependency.Requirement {
        return .revisionItem(ref)
    }

    /// Returns a requirement for a source control branch.
    ///
    /// Note that packages that use branch-based dependency requirements
    /// can't be depended upon by packages that use version-based dependency
    /// requirements; you should remove branch-based dependency requirements
    /// before publishing a version of your package.
    ///
    /// The following example defines a version requirement that accepts any
    /// change in the develop branch.
    ///
    ///    .branch("develop")
    ///
    /// - Parameters:
    ///     - name: The name of the branch.
    @available(_PackageDescription, deprecated: 5.6)
    public static func branch(_ name: String) -> Package.Dependency.Requirement {
        return .branchItem(name)
    }
}

// MARK: - SourceControlRequirement

extension Package.Dependency {
    /// An enum that represents the requirement for a package dependency.
    ///
    /// The dependency requirement can be defined as one of three different version requirements:
    ///
    /// **A version-based requirement.**
    ///
    /// Decide whether your project accepts updates to a package dependency up
    /// to the next major version or up to the next minor version. To be more
    /// restrictive, select a specific version range or an exact version.
    /// Major versions tend to have more significant changes than minor
    /// versions, and may require you to modify your code when they update.
    /// The version rule requires Swift packages to conform to semantic
    /// versioning. To learn more about the semantic versioning standard,
    /// visit [semver.org](https://semver.org).
    ///
    /// Selecting the version requirement is the recommended way to add a package dependency. It allows you to create a balance between restricting changes and obtaining improvements and features.
    ///
    /// **A branch-based requirement**
    ///
    /// Select the name of the branch for your package dependency to follow.
    /// Use branch-based dependencies when you're developing multiple packages
    /// in tandem or when you don't want to publish versions of your package dependencies.
    ///
    /// Note that packages which use branch-based dependency requirements
    /// can't be added as dependencies to packages that use version-based dependency
    /// requirements; you should remove branch-based dependency requirements
    /// before publishing a version of your package.
    ///
    /// **A commit-based requirement**
    ///
    /// Select the commit hash for your package dependency to follow.
    /// Choosing this option isn't recommended, and should be limited to
    /// exceptional cases. While pinning your package dependency to a specific
    /// commit ensures that the package dependency doesn't change and your
    /// code remains stable, you don't receive any updates at all. If you worry about
    /// the stability of a remote package, consider one of the more
    /// restrictive options of the version-based requirement.
    ///
    /// Note that packages which use commit-based dependency requirements
    /// can't be added as dependencies to packages that use version-based
    /// dependency requirements; you should remove commit-based dependency
    /// requirements before publishing a version of your package.
    public enum SourceControlRequirement {
        case exact(Version)
        case range(Range<Version>)
        case revision(String)
        case branch(String)
    }
}

// MARK: - RegistryRequirement

extension Package.Dependency {
    /// An enum that represents the requirement for a package dependency.
    ///
    /// The dependency requirement can be defined as one of three different version requirements:
    ///
    /// **A version-based requirement.**
    ///
    /// Decide whether your project accepts updates to a package dependency up
    /// to the next major version or up to the next minor version. To be more
    /// restrictive, select a specific version range or an exact version.
    /// Major versions tend to have more significant changes than minor
    /// versions, and may require you to modify your code when they update.
    /// The version rule requires Swift packages to conform to semantic
    /// versioning. To learn more about the semantic versioning standard,
    /// visit [semver.org](https://semver.org).
    ///
    /// Selecting the version requirement is the recommended way to add a package dependency. It allows you to create a balance between restricting changes and obtaining improvements and features.
    ///
    /// **A branch-based requirement**
    ///
    /// Select the name of the branch for your package dependency to follow.
    /// Use branch-based dependencies when you're developing multiple packages
    /// in tandem or when you don't want to publish versions of your package dependencies.
    ///
    /// Note that packages which use branch-based dependency requirements
    /// can't be added as dependencies to packages that use version-based dependency
    /// requirements; you should remove branch-based dependency requirements
    /// before publishing a version of your package.
    ///
    /// **A commit-based requirement**
    ///
    /// Select the commit hash for your package dependency to follow.
    /// Choosing this option isn't recommended, and should be limited to
    /// exceptional cases. While pinning your package dependency to a specific
    /// commit ensures that the package dependency doesn't change and your
    /// code remains stable, you don't receive any updates at all. If you worry about
    /// the stability of a remote package, consider one of the more
    /// restrictive options of the version-based requirement.
    ///
    /// Note that packages which use commit-based dependency requirements
    /// can't be added as dependencies to packages that use version-based
    /// dependency requirements; you should remove commit-based dependency
    /// requirements before publishing a version of your package.
    public enum RegistryRequirement {
        case exact(Version)
        case range(Range<Version>)
    }
}

extension Range {
    /// Returns a requirement for a version range, starting at the given minimum
    /// version and going up to the next major version. This is the recommended version requirement.
    ///
    /// - Parameters:
    ///     - version: The minimum version for the version range.
    public static func upToNextMajor(from version: Version) -> Range<Bound> where Bound == Version {
        return version ..< Version(version.major + 1, 0, 0)
    }


    /// Returns a requirement for a version range, starting at the given minimum
    /// version and going up to the next minor version.
    ///
    /// - Parameters:
    ///     - version: The minimum version for the version range.
    public static func upToNextMinor(from version: Version) -> Range<Bound> where Bound == Version {
        return version ..< Version(version.major, version.minor + 1, 0)
    }
}
