//
//  HTTPHeaderTests.swift
//  
//
//  Created by Bram Kolkman on 19/10/2022.
//

import XCTest
@testable import HTTP

final class HTTPHeaderTests: XCTestCase {
    let tests: [(String, HTTPHeader)] = [
        ("Accept: application/json", .accept(.applicationJSON)),
        ("Authorization: Basic YWxhZGRpbjpvcGVuc2VzYW1l", .authorization("Basic YWxhZGRpbjpvcGVuc2VzYW1l")),
        ("Content-Length: 5", .contentLength(5)),
        ("Content-Type: text/plain", .contentType(.textPlain)),
        ("User-Agent: curl/7.64.1", .userAgent("curl/7.64.1")),
        ("Accept-Encoding: gzip, deflate", HTTPHeader(name: "Accept-Encoding", value: "gzip, deflate"))
    ]

    func testRawValues() throws {
        for test in tests {
            XCTAssertEqual(test.0, test.1.rawValue)
        }
    }

    func testRawValueInitializer() throws {
        let header = try XCTUnwrap(HTTPHeader(rawValue: "Accept-Encoding: gzip, deflate"))
        XCTAssertEqual("Accept-Encoding: gzip, deflate", header.rawValue)

        XCTAssertNil(HTTPHeader(rawValue: ""))
    }
}
