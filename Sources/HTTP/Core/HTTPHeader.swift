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

import Foundation

/// A container for HTTP headers.
public struct HTTPHeader: RawRepresentable, Sendable {
    public typealias RawValue = String

    /// The name of the header.
    public let name: String
    /// The value of the header.
    public let value: String

    public var rawValue: RawValue {
        "\(name): \(value)"
    }

    /// Create the HTTP header from its components.
    /// - Parameters:
    ///   - name: The name of the header.
    ///   - value: The value of the header.
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    public init?(rawValue: RawValue) {
        let components = rawValue
            .split(separator: ":", maxSplits: 1)
            .map(String.init)
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }

        guard components.count == 2,
              let name = components.first,
              let value = components.last else {
            return nil
        }
        self.init(name: name, value: value)
    }
}

extension HTTPHeader: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(value)
    }
}

extension HTTPHeader {
    /// Informs the server about the types of data that can be sent back.
    /// - Parameter mediaType: The accepted media type.
    public static func accept(_ mediaType: MediaType) -> HTTPHeader {
        HTTPHeader(name: "Accept", value: mediaType.rawValue)
    }

    /// Contains the credentials to authenticate a user-agent with a server.
    /// - Parameter value: The value of the header.
    public static func authorization(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: value)
    }

    /// The size of the resource, in decimal number of bytes.
    /// - Parameter length: The size of the content.
    public static func contentLength(_ length: Int) -> HTTPHeader {
        HTTPHeader(name: "Content-Length", value: String(length))
    }

    /// Indicates the media type of the resource.
    /// - Parameter mediaType: The media type of the request.
    public static func contentType(_ mediaType: MediaType) -> HTTPHeader {
        HTTPHeader(name: "Content-Type", value: mediaType.rawValue)
    }

    /// Contains a characteristic string that allows the network protocol peers to identify
    /// the application type, operating system, software vendor or software version of
    /// the requesting software user agent.
    /// - Parameter agent: The user agent.
    public static func userAgent(_ agent: String) -> HTTPHeader {
        HTTPHeader(name: "User-Agent", value: agent)
    }
}

extension Array where Element == HTTPHeader {
    /// Find the header by its name.
    /// - Parameter name: The name of the header.
    /// - Returns: The HTTP header if found, otherwise `nil`.
    public subscript(name: String) -> HTTPHeader? {
        first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame })
    }
}
