//
//  AcceptHeaderValidationMiddleware.swift
//  
//
//  Created by Bram Kolkman on 26/10/2022.
//

import Foundation

/// Middleware to validate the `Content-Type` header.
public struct AcceptHeaderValidationMiddleware: Middleware {
    /// Get the `Content-Type` header value.
    /// - Parameter header: The header.
    /// - Returns: The content type or `nil` if there was no value.
    private func contentType(for header: HTTPHeader) -> String? {
        let value = header.value.split(separator: ";").first.map(String.init)
        switch value {
        case .some(let value) where !value.isEmpty:
            return value
        default:
            return nil
        }
    }

    public func process(response: HTTPResponse) async throws {
        guard let requestHeader = response.originalRequest.headers["Accept"],
              let requestAcceptType = contentType(for: requestHeader) else {
            return
        }
        guard let responseHeader = response.headers["Content-Type"],
              let responseContentType = contentType(for: responseHeader) else {
            throw URLError(.invalidContentType, userInfo: [
                NSURLErrorKey: response.originalRequest.url,
                NSURLErrorExpectedMediaTypeKey: requestHeader.value
            ])
        }
        guard requestAcceptType.caseInsensitiveCompare(responseContentType) == .orderedSame else {
            throw URLError(.invalidContentType, userInfo: [
                NSURLErrorKey: response.originalRequest.url,
                NSURLErrorExpectedMediaTypeKey: requestAcceptType,
                NSURLErrorReceivedMediaTypeKey: responseContentType
            ])
        }
    }
}
