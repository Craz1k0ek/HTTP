//
//  StatusCodeValidationMiddleware.swift
//  
//
//  Created by Bram Kolkman on 26/10/2022.
//

import Foundation

public struct StatusCodeValidationMiddleware: Middleware {
    /// The range of allowed status  codes.
    public let allowedStatusCodes: ClosedRange<HTTPStatusCode>

    /// Create the middleware.
    /// - Parameter allowedStatusCodes: The allowed status codes.
    public init(allowedStatusCodes: ClosedRange<HTTPStatusCode>) {
        self.allowedStatusCodes = allowedStatusCodes
    }

    /// Create the middleware.
    /// - Parameters:
    ///   - min: The minimum status code.
    ///   - max: The maximum status code.
    public init(min: HTTPStatusCode, max: HTTPStatusCode) {
        self.init(allowedStatusCodes: min...max)
    }

    public func process(response: HTTPResponse) async throws {
        guard allowedStatusCodes ~= response.statusCode else {
            throw URLError(.badStatusCode, userInfo: [
                NSURLErrorKey: response.originalRequest.url,
                NSURLErrorStatusCodeKey: response.statusCode
            ])
        }
    }
}

extension Middleware where Self == StatusCodeValidationMiddleware {
    /// A status code validator to validate `2xx` statuses.
    public static var successOnly: StatusCodeValidationMiddleware { StatusCodeValidationMiddleware(min: 200, max: 299) }
}
