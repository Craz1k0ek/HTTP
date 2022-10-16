//
//  HTTPMethodTests.swift
//
//
//  Created by Bram Kolkman on 16/10/2022.
//

import XCTest
@testable import HTTP

final class HTTPMethodTests: XCTestCase {
    func testRawValues() {
        for method in HTTPMethod.allCases {
            XCTAssertEqual("\(method)".uppercased(), method.rawValue)
        }
    }

    func testRawValueInitializer() throws {
        for method in HTTPMethod.allCases {
            let uppercased = try XCTUnwrap(HTTPMethod(rawValue: method.rawValue))
            let lowercased = try XCTUnwrap(HTTPMethod(rawValue: method.rawValue.lowercased()))

            XCTAssertEqual(uppercased, method)
            XCTAssertEqual(lowercased, method)
        }
    }

    func testInvalidRawValueInitializer() {
        XCTAssertNil(HTTPMethod(rawValue: #function))
    }

    func testStringExpressible() throws {
        let upper = ["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
        let lower = ["get", "head", "post", "put", "delete", "connect", "options", "trace", "patch"]
        let methods: [HTTPMethod] = [.get, .head, .post, .put, .delete, .connect, .options, .trace, .patch]

        for (string, method) in zip(zip(upper, lower), methods) {
            let lower: HTTPMethod = HTTPMethod(stringLiteral: "\(string.0)")
            let upper: HTTPMethod = HTTPMethod(stringLiteral: "\(string.1)")
            XCTAssertEqual(lower, method)
            XCTAssertEqual(upper, method)
        }
    }
}
