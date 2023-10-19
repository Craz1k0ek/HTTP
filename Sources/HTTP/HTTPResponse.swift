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

import Combine
import Foundation

/// An HTTP response object.
public struct HTTPResponse: Identifiable, Sendable {
    /// The stable identity of the entity associated with this instance.
    public let id: UUID

    /// The original request of the response.
    public let originalRequest: HTTPRequest
    /// The response status code.
    public let statusCode: HTTPStatusCode
    /// The response headers.
    public let headers: [HTTPHeader]
    /// The response body.
    public let body: Data
    /// The text encoding.
    public let textEncoding: String.Encoding

    /// Create an HTTP response.
    /// - Parameters:
    ///   - id: The unique identifier of the response.
    ///   - originalRequest: The original request of the response.
    ///   - statusCode: The response status code.
    ///   - headers: The response headers.
    ///   - body: The response body.
    ///   - textEncoding: The text encoding.
    public init(
        id: UUID = UUID(),
        originalRequest: HTTPRequest,
        statusCode: HTTPStatusCode,
        headers: [HTTPHeader] = [],
        body: Data = Data(),
        textEncoding: String.Encoding = .utf8
    ) {
        self.id = id
        self.originalRequest = originalRequest
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
        self.textEncoding = textEncoding
    }

    /// Decode the HTTP body to a `Decodable` type.
    /// - Parameters:
    ///   - type: The resulting type.
    ///   - decoder: The decoder used to decode the body.
    /// - Returns: The decoded object.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func decode<T: Decodable, D: TopLevelDecoder>(to type: T.Type, using decoder: D = JSONDecoder()) throws -> T where D.Input == Data {
        try decoder.decode(type, from: body)
    }
}

extension HTTPResponse: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(originalRequest)
        hasher.combine(statusCode)
        hasher.combine(headers)
        hasher.combine(body)
        hasher.combine(textEncoding)
    }
}

public protocol HTTPResponseConvertible {
    /// Convert an object from an `HTTPResponse`.
    /// - Parameter response: The response to convert.
    /// - Returns: The converted object.
    static func convert(from response: HTTPResponse) throws -> Self
}

extension HTTPResponse: HTTPResponseConvertible {
    public static func convert(from response: HTTPResponse) throws -> HTTPResponse {
        return response
    }
}
