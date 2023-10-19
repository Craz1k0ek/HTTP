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

/// An HTTP request object.
public struct HTTPRequest: Identifiable, Sendable {
    /// The stable identity of the entity associated with this instance.
    public let id: UUID

    /// The URL of the request.
    public let url: URL
    /// The HTTP method.
    public let method: HTTPMethod
    /// The request headers.
    public var headers: [HTTPHeader]
    /// The HTTP body.
    public var body: Data?
    /// The request timeout.
    public let timeout: TimeInterval

    /// Create an HTTP request.
    /// - Parameters:
    ///   - id: The unique identifier of the request.
    ///   - url: The URL of the request.
    ///   - method: The HTTP method.
    ///   - headers: The headers of the request.
    ///   - body: The HTTP body.
    ///   - timeout: The timeout of the request.
    public init(
        id: UUID = UUID(),
        url: URL,
        method: HTTPMethod = .get,
        headers: [HTTPHeader] = [],
        body: Data? = nil,
        timeout: TimeInterval = 60
    ) {
        self.id = id
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.timeout = timeout
    }
}

extension HTTPRequest: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
        hasher.combine(method)
        hasher.combine(headers)
        hasher.combine(body)
        hasher.combine(timeout)
    }
}

public protocol HTTPRequestConvertible {
    /// Convert the object to an `HTTPRequest`.
    var httpRequest: HTTPRequest { get throws }
}

extension HTTPRequest: HTTPRequestConvertible {
    public var httpRequest: HTTPRequest { return self }
}
