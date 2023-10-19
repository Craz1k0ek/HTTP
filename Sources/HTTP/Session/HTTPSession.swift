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

/// A type describing an HTTP session.
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public protocol HTTPSession: Sendable {
    /// Fetch an HTTP response from a server by sending an HTTP request.
    /// - Parameter request: The request to send.
    /// - Returns: The received response.
    func response(for request: HTTPRequest) async throws -> HTTPResponse
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public extension HTTPSession {
    /// Fetch an HTTP response from a server by sending an HTTP request.
    /// - Parameters:
    ///   - type: The expected type of HTTP response to receive..
    ///   - request: The request to send.
    /// - Returns: The HTTP response.
    func response<T: HTTPResponseConvertible>(_ type: T.Type = HTTPResponse.self, for request: HTTPRequestConvertible) async throws -> T {
        try await type.convert(from: response(for: request.httpRequest))
    }
}
