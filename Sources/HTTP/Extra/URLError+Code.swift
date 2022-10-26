//
//  File.swift
//  
//
//  Created by Bram Kolkman on 26/10/2022.
//

import Foundation

extension URLError {
    /// A bad status code error instance.
    public static var badStatusCode: URLError.Code { .badStatusCode }
    /// A bad `Content-Type` header instance.
    public static var invalidContentType: URLError.Code { .invalidContentType }
}

extension URLError.Code {
    /// The error code for a bad status error.
    public static let badStatusCode = URLError.Code(rawValue: -1046)
    /// The error code for an invalid `Content-Type` header.
    public static let invalidContentType = URLError.Code(rawValue: -1047)
}

/// The corresponding value is an `HTTPStatusCode` object.
public let NSURLErrorStatusCodeKey = "NSURLStatusCode"
/// The corresponding value is a `String` object.
public let NSURLErrorExpectedMediaTypeKey = "NSURLExpectedMediaType"
/// The corresponding value is a `String` object.
public let NSURLErrorReceivedMediaTypeKey = "NSURLReceivedMediaType"
