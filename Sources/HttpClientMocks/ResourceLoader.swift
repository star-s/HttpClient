//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.03.2024.
//

import Foundation
import CoreServices
import UniformTypeIdentifiers
import HttpClientUtilities

public struct ResourceLoader {
    private let bundle: Bundle
    private let pathComponents: [String]

    public init(bundle: Bundle, pathPrefix: String? = nil) {
        self.bundle = bundle
        self.pathComponents = pathPrefix.map {
            let path = ($0 as NSString).standardizingPath as NSString
            var components = path.pathComponents
            if path.isAbsolutePath {
                components.removeFirst()
            }
            return components
        } ?? []
    }

    @available(iOS, deprecated: 14.0, message: "Use loadResource(_:type:) instead.")
    @available(tvOS, deprecated: 14.0, message: "Use loadResource(_:type:) instead.")
    @available(macOS, deprecated: 11.0, message: "Use loadResource(_:type:) instead.")
    @available(watchOS, deprecated: 7.0, message: "Use loadResource(_:type:) instead.")
    public func loadResource(_ path: String, uti: CFString) throws -> TaggedData {
        let path = path.trimmingCharacters(in: CharacterSet(charactersIn: "/").union(.whitespacesAndNewlines))
        let pathComponents = pathComponents + path.pathComponentsWithoutFilename

        guard let url = bundle.url(
            forResource: path.filenameWithoutExtension,
            withExtension: path.filenameExtension(uti: uti),
            subdirectory: pathComponents.isEmpty ? nil : NSString.path(withComponents: pathComponents)
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try Data(contentsOf: url).tag(as: uti)
    }

    @available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *)
    public func loadResource(_ path: String, type: UTType) throws -> TaggedData {
        let path = path.trimmingCharacters(in: CharacterSet(charactersIn: "/").union(.whitespacesAndNewlines))
        let pathComponents = pathComponents + path.pathComponentsWithoutFilename

        guard let url = bundle.url(
            forResource: path.filenameWithoutExtension,
            withExtension: path.filenameExtension(type),
            subdirectory: pathComponents.isEmpty ? nil : NSString.path(withComponents: pathComponents)
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }
        let data = try Data(contentsOf: url)
        guard let mimeType = type.preferredMIMEType else {
            return data.tagged(with: [])
        }
        return data.tagged(.mimeType(mimeType))
    }
}

private extension String {
    var filenameWithoutExtension: String {
        let path = self as NSString
        if path.pathExtension.isEmpty {
            return path.lastPathComponent
        }
        return (path.lastPathComponent as NSString).deletingPathExtension
    }

    var pathComponentsWithoutFilename: [String] {
        (((self as NSString).lastPathComponent as NSString).deletingLastPathComponent as NSString).pathComponents
    }

    func filenameExtension(uti: CFString) -> String? {
        let path = self as NSString
        if path.pathExtension.isEmpty {
            return (UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension)?.takeRetainedValue() as NSString?) as String?
        }
        return path.pathExtension
    }

    @available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *)
    func filenameExtension(_ type: UTType) -> String? {
        let path = self as NSString
        if path.pathExtension.isEmpty {
            return type.preferredFilenameExtension
        }
        return path.pathExtension
    }
}
