//
//  StandardHTTPClient.swift
//  
//
//  Created by Bram Kolkman on 24/10/2022.
//

import Foundation

public struct StandardHTTPClient: HTTPClient {
    public var middleware: [Middleware]
    /// The underlying `URLSession`.
    private let session: URLSession

    /// Create the client.
    /// - Parameters:
    ///   - session: The underlying session.
    ///   - middleware: The client's middleware.
    public init(session: URLSession = .shared, middleware: [Middleware] = []) {
        self.session = session
        self.middleware = middleware
    }

    public func send(request: HTTPRequest) async throws -> HTTPResponse {
        let request = try await middleware.asyncReduce(into: request) { request, middleware in
            try await middleware.process(request: &request)
        }
        guard let (body, urlResponse) = try await session.data(for: request.urlRequest) as? (Data, HTTPURLResponse) else {
            throw URLError(.badServerResponse, userInfo: [
                NSURLErrorKey: request.url,
                NSHelpAnchorErrorKey: "Expecting HTTPURLResponse object, got URLResponse object instead"
            ])
        }
        let response = HTTPResponse(request: request, response: urlResponse, body: body)
        try await middleware.asyncForEach { middleware in
            try await middleware.process(response: response)
        }
        return response
    }
}
