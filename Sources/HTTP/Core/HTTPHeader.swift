//
//  HTTPHeader.swift
//  
//
//  Created by Bram Kolkman on 18/10/2022.
//

public struct HTTPHeader: RawRepresentable, Sendable {
    public typealias RawValue = String

    /// The name of the header.
    public let name: String
    /// The value of the header.
    public let value: String

    public var rawValue: String {
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

    public init?(rawValue: String) {
        let components = rawValue
            .split(separator: ":", maxSplits: 1)
            .map(String.init)
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        guard let name = components.first, let value = components.last else { return nil }
        self.init(name: name.trimmingCharacters(in: .whitespaces), value: value)
    }
}

extension HTTPHeader: Equatable {}

extension HTTPHeader: Hashable {}

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
