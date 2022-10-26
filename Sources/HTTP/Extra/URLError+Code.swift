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
}

extension URLError.Code {
    /// The error code for a bad status error.
    public static let badStatusCode: URLError.Code = URLError.Code(rawValue: -1046)
}

public let NSURLErrorStatusCodeKey = "NSURLStatusCode"
