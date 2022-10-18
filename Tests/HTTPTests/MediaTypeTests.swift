//
//  MediaTypeTests.swift
//  
//
//  Created by Bram Kolkman on 18/10/2022.
//

import XCTest
@testable import HTTP

final class MediaTypeTests: XCTestCase {
    let tests: [(String, MediaType)] = [
        ("text/plain", .textPlain),
        ("application/octet-stream", .applicationOctetStream),
        ("application/json", .applicationJSON),
        ("multipart/form-data", .multipartFormData),
        ("multipart/form-data; boundary=123", .multipartFormData(boundary: "123")),
        ("text/html", "text/html")
    ]

    func testRawValues() {
        for test in tests {
            XCTAssertEqual(test.0, test.1.rawValue)
        }
    }

    func testMultipartEmptyBoundary() {
        let multipart = MediaType.multipartFormData(boundary: "")
        XCTAssertEqual(multipart, MediaType.multipartFormData)
    }
}
