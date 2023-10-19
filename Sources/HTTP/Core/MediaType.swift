//  Copyright 2023 Thinkerium
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

/// Media types used in several HTTP headers.
public struct MediaType: RawRepresentable, Sendable {
    public typealias RawValue = String

    public let rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

extension MediaType: ExpressibleByStringLiteral {
    public typealias StringLiteralType = RawValue

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension MediaType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

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
        boundary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? MediaType.multipartFormData : MediaType(stringLiteral: "multipart/form-data; boundary=\(boundary)")
    }
}
