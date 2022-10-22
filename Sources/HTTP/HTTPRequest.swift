//
//  HTTPRequest.swift
//  
//
//  Created by Bram Kolkman on 19/10/2022.
//

import Foundation

public struct HTTPRequest: @unchecked Sendable {
    /// The URL of the request.
    public let url: URL
    /// The HTTP method.
    public var method: HTTPMethod
    /// The request headers.
    public var headers: [HTTPHeader]
    /// The HTTP body.
    public var body: Data?
    /// The request timeout.
    public var timeout: TimeInterval

    /// Create an HTTP request.
    /// - Parameters:
    ///   - url: The URL of the request.
    ///   - method: The HTTP method.
    ///   - headers: The headers of the request.
    ///   - body: The HTTP body.
    ///   - timeout: The timeout of the request.
    public init(url: URL, method: HTTPMethod = .get, headers: [HTTPHeader] = [], body: Data? = nil, timeout: TimeInterval = 60) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.timeout = timeout
    }

    /// Create an HTTP request from an `URLRequest`.
    /// - Parameter request: The URL request.
    internal init?(request: URLRequest) {
        guard let url = request.url else {
            return nil
        }
        self.url = url
        self.method = HTTPMethod(rawValue: request.httpMethod ?? "GET") ?? .get
        self.headers = (request.allHTTPHeaderFields ?? [:]).reduce(into: [HTTPHeader](), { headers, header in
            headers.append(HTTPHeader(name: header.key, value: header.value))
        })
        self.body = request.httpBody
        self.timeout = request.timeoutInterval
    }

    /// Generate the `URLRequest` from the request.
    internal var urlRequest: URLRequest {
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        request.httpBody = body
        return request
    }
}

extension HTTPRequest: Equatable {}

extension HTTPRequest: Hashable {}
