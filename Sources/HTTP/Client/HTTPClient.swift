//
//  HTTPClient.swift
//  
//
//  Created by Bram Kolkman on 24/10/2022.
//

/// The HTTP client protocol is used to implement a client.
public protocol HTTPClient {
    /// The middleware of the client.
    var middleware: [Middleware] { get set }

    /// Send an HTTP request to the server.
    /// - Parameter request: The request to send.
    /// - Returns: The server's response.
    func send(request: HTTPRequest) async throws -> HTTPResponse
}
