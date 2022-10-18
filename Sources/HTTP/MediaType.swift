//
//  MediaType.swift
//  
//
//  Created by Bram Kolkman on 17/10/2022.
//

import Foundation

/// Media types used in several HTTP headers.
public struct MediaType: RawRepresentable {
    public typealias RawValue = String

    /// The underlying value.
    private let mediaType: String

    public var rawValue: String {
        return mediaType
    }

    public init?(rawValue: String) {
        self.mediaType = rawValue
    }
}

extension MediaType: ExpressibleByStringLiteral {
    public typealias StringLiteralType = MediaType.RawValue

    public init(stringLiteral value: RawValue) {
        self.init(rawValue: value)!
    }
}

extension MediaType: Equatable {}

extension MediaType: Hashable {}

extension MediaType {
    /// The default media type for textual files.
    public static let textPlain: MediaType = "text/plain"

    /// The default media type for binary files.
    public static let applicationOctetStream: MediaType = "application/octet-stream"
    /// The application JSON media type.
    public static let applicationJSON: MediaType = "application/json"

    /// The multipart form data media type.
    public static var multipartFormData: MediaType = "multipart/form-data"
    /// The multipart form data media type with a boundary.
    /// - Parameter boundary: The boundary of the media type.
    public static func multipartFormData(boundary: String) -> MediaType {
        boundary.isEmpty ? MediaType.multipartFormData : MediaType(stringLiteral: "multipart/form-data; boundary=\(boundary)")
    }
}
