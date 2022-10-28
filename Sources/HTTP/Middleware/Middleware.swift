//
//  Middleware.swift
//  
//
//  Created by Bram Kolkman on 23/10/2022.
//

/// The middleware protocol is used to customise client behaviour.
public protocol Middleware {
    /// Process the request before sending it.
    /// - Parameter request: The request to process.
    func process(request: inout HTTPRequest) async throws

    /// Process the response before sending it.
    /// - Parameter response: The response to process.
    func process(response: HTTPResponse) async throws
}

public extension Middleware {
    func process(request: inout HTTPRequest) async throws {}
    func process(response: HTTPResponse) async throws {}
}
