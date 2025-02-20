/*
 This source file is part of the Swift.org open source project
 
 Copyright (c) 2014 - 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception
 
 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
 */

import XCTest

import TSCBasic
import TSCUtility
import SPMTestSupport
import PackageModel
import PackageLoading

class PackageDescriptionLoadingTests: XCTestCase {
    let manifestLoader = ManifestLoader(manifestResources: Resources.default)
    
    var toolsVersion: ToolsVersion {
        fatalError("implement in subclass")
    }
    
    func loadManifestThrowing(
        _ contents: String,
        toolsVersion: ToolsVersion? = nil,
        packageKind: PackageReference.Kind = .local,
        file: StaticString = #file,
        line: UInt = #line,
        body: (Manifest) -> Void
    ) throws {
        try self.loadManifestThrowing(ByteString(encodingAsUTF8: contents),
                                      toolsVersion: toolsVersion,
                                      packageKind: packageKind,
                                      file: file,
                                      line: line,
                                      body: body)
    }

    // TODO: deprecate in favor of String version
    func loadManifestThrowing(
        _ contents: ByteString,
        toolsVersion: ToolsVersion? = nil,
        packageKind: PackageReference.Kind = .local,
        file: StaticString = #file,
        line: UInt = #line,
        body: (Manifest) -> Void
    ) throws {
        let toolsVersion = toolsVersion ?? self.toolsVersion
        let fs = InMemoryFileSystem()
        let manifestPath = AbsolutePath.root.appending(component: Manifest.filename)
        try fs.writeFileContents(manifestPath, bytes: contents)
        let m = try manifestLoader.load(
            at: AbsolutePath.root,
            packageKind: packageKind,
            packageLocation: "/foo",
            toolsVersion: toolsVersion,
            fileSystem: fs)
        guard m.toolsVersion == toolsVersion else {
            return XCTFail("Invalid manifest version", file: file, line: line)
        }
        body(m)
    }
    
    func loadManifest(
        _ contents: String,
        toolsVersion: ToolsVersion? = nil,
        packageKind: PackageReference.Kind = .local,
        line: UInt = #line,
        body: (Manifest) -> Void
    ) {
        self.loadManifest(ByteString(encodingAsUTF8: contents),
                          toolsVersion: toolsVersion,
                          packageKind: packageKind,
                          line: line,
                          body: body)
    }

    // TODO: deprecate in favor of String version
    func loadManifest(
        _ contents: ByteString,
        toolsVersion: ToolsVersion? = nil,
        packageKind: PackageReference.Kind = .local,
        line: UInt = #line,
        body: (Manifest) -> Void
    ) {
        do {
            let toolsVersion = toolsVersion ?? self.toolsVersion
            try loadManifestThrowing(
                contents,
                toolsVersion: toolsVersion,
                packageKind: packageKind,
                line: line,
                body: body
            )
        } catch ManifestParseError.invalidManifestFormat(let error, _) {
            print(error)
            XCTFail(file: #file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: #file, line: line)
        }
    }

    func XCTAssertManifestLoadNoThrows(
        _ contents: String,
        toolsVersion: ToolsVersion? = nil,
        packageKind: PackageReference.Kind = .local,
        file: StaticString = #file,
        line: UInt = #line,
        onSuccess: ((Manifest, DiagnosticsEngineResult) -> Void)? = nil
    ) {
        let diagnostics = DiagnosticsEngine()
        
        do {
            let manifest = try loadManifest(
                contents,
                toolsVersion: toolsVersion ?? self.toolsVersion,
                packageKind: packageKind,
                diagnostics: diagnostics,
                file: file,
                line: line)
            
            if let onSuccess = onSuccess {
                DiagnosticsEngineTester(diagnostics) { result in
                    onSuccess(manifest, result)
                }
            }
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }

    func XCTAssertManifestLoadThrows(
        _ contents: String,
        toolsVersion: ToolsVersion? = nil,
        packageKind: PackageReference.Kind = .local,
        file: StaticString = #file,
        line: UInt = #line,
        onCatch: ((Error, DiagnosticsEngineResult) -> Void)? = nil
    ) {
        let diagnostics = DiagnosticsEngine()
        
        do {
            let manifest = try loadManifest(
                contents,
                toolsVersion: toolsVersion ?? self.toolsVersion,
                packageKind: packageKind,
                diagnostics: diagnostics,
                file: file,
                line: line)
            
            XCTFail("Unexpected success: \(manifest)", file: file, line: line)
        } catch {
            if let onCatch = onCatch {
                DiagnosticsEngineTester(diagnostics, file: file, line: line) { result in
                    onCatch(error, result)
                }
            }
        }
    }
    
    func XCTAssertManifestLoadThrows<E: Error & Equatable>(
        _ expectedError: E,
        _ contents: String,
        toolsVersion: ToolsVersion? = nil,
        packageKind: PackageReference.Kind = .local,
        file: StaticString = #file,
        line: UInt = #line,
        onCatch: ((DiagnosticsEngineResult) -> Void)? = nil
    ) {
        XCTAssertManifestLoadThrows(contents, toolsVersion: toolsVersion, file: file, line: line) { error, result in
            if let typedError = error as? E, typedError == expectedError {
                // Everything okay
            } else {
                XCTFail("Unexpected error: \(error)", file: file, line: line)
            }
            
            onCatch?(result)
        }
    }
    
    func loadManifest(
        _ contents: String,
        toolsVersion: ToolsVersion?,
        packageKind: PackageReference.Kind,
        diagnostics: DiagnosticsEngine?,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Manifest {
        let toolsVersion = toolsVersion ?? self.toolsVersion
        let fileSystem = InMemoryFileSystem()
        let manifestPath = AbsolutePath.root.appending(component: Manifest.filename)
        try fileSystem.writeFileContents(manifestPath, bytes: ByteString(encodingAsUTF8: contents))
        let manifest = try manifestLoader.load(
            at: AbsolutePath.root,
            packageKind: packageKind,
            packageLocation: "/foo",
            toolsVersion: toolsVersion,
            fileSystem: fileSystem,
            diagnostics: diagnostics)
        
        if manifest.toolsVersion != toolsVersion {
            XCTFail("Invalid manifest version", file: file, line: line)
        }
        
        return manifest
    }
}
