//
//  HTTPResponse.swift
//  
//
//  Created by Bram Kolkman on 20/10/2022.
//

import Foundation

public struct HTTPResponse: @unchecked Sendable {
    /// The original request of the response.
    public let originalRequest: HTTPRequest
    /// The response status code.
    public let statusCode: HTTPStatusCode
    /// The response headers.
    public let headers: [HTTPHeader]
    /// The response body.
    public let body: Data

    /// Create the response.
    /// - Parameters:
    ///   - originalRequest: The original request.
    ///   - statusCode: The status code.
    ///   - headers: The headers.
    ///   - body: The body.
    public init(originalRequest: HTTPRequest, statusCode: HTTPStatusCode, headers: [HTTPHeader], body: Data) {
        self.originalRequest = originalRequest
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
    }

    /// Create the response from an `HTTPURLResponse`.
    /// - Parameters:
    ///   - request: The original request.
    ///   - response: The response.
    ///   - body: The body.
    internal init(request: HTTPRequest, response: HTTPURLResponse, body: Data) {
        self.originalRequest = request
        self.statusCode = HTTPStatusCode(rawValue: response.statusCode)!
        self.headers = response.allHeaderFields.reduce(into: [HTTPHeader]()) { headers, header in
            if let name = header.key as? String, let value = header.value as? String {
                headers.append(HTTPHeader(name: name, value: value))
            }
        }
        self.body = body
    }
}

extension HTTPResponse: Equatable {}

extension HTTPResponse: Hashable {}
