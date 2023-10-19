//  Copyright 2023 Thinkerium
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

@testable import HTTP
import XCTest

final class HTTPHeaderTests: XCTestCase {
    func testHeaderInitNameValue() {
        let name = UUID().uuidString
        let value = UUID().uuidString
        let rawValue = "\(name): \(value)"

        let header = HTTPHeader(name: name, value: value)
        XCTAssertEqual(header.name, name)
        XCTAssertEqual(header.value, value)
        XCTAssertEqual(header.rawValue, rawValue)
    }

    func testHeaderInitRawValue() throws {
        let name = UUID().uuidString
        let value = UUID().uuidString
        let rawValue = "\(name): \(value)"

        let header = try XCTUnwrap(HTTPHeader(rawValue: "\(name): \(value)"))
        XCTAssertEqual(header.name, name)
        XCTAssertEqual(header.value, value)
        XCTAssertEqual(header.rawValue, rawValue)
    }

    func testHeaderInitRawValueWhiteSpaces() throws {
        let name = UUID().uuidString
        let value = UUID().uuidString

        let rawValues = [
            "\(name):\(value)",
            " \(name):\(value)",
            "\(name) :\(value)",
            " \(name) :\(value)",

            "\(name): \(value)",
            "\(name):\(value) ",
            "\(name): \(value) "
        ]

        try rawValues.forEach { rawValue in
            let header = try XCTUnwrap(HTTPHeader(rawValue: rawValue))
            XCTAssertEqual(header.name, name)
            XCTAssertEqual(header.value, value)
        }
    }

    func testMalformedRawValue() {
        XCTAssertNil(HTTPHeader(rawValue: UUID().uuidString))
    }

    func testHashableConformance() {
        let firstName = UUID().uuidString
        let firstValue = UUID().uuidString
        let first = HTTPHeader(name: firstName, value: firstValue)
        let firstReplica = HTTPHeader(name: firstName, value: firstValue)
        XCTAssertEqual(first.hashValue, firstReplica.hashValue)

        let secondName = UUID().uuidString
        let second = HTTPHeader(name: secondName, value: firstValue)
        XCTAssertNotEqual(first.hashValue, second.hashValue)

        let thirdValue = UUID().uuidString
        let third = HTTPHeader(name: firstName, value: thirdValue)
        XCTAssertNotEqual(third.hashValue, second.hashValue)
    }

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
        let rawValue = "Accept-Encoding: gzip, deflate"
        let header = try XCTUnwrap(HTTPHeader(rawValue: rawValue))
        XCTAssertEqual(rawValue, header.rawValue)

        XCTAssertNil(HTTPHeader(rawValue: ""))
    }

    func testHeaderArraySubscript() {
        let headers: [HTTPHeader] = [
            .contentType(.applicationJSON),
            .contentLength(5)
        ]

        XCTAssertNotNil(headers["Content-Type"])
        XCTAssertNotNil(headers["content-type"])
        XCTAssertNotNil(headers["Content-Length"])
        XCTAssertNotNil(headers["content-length"])
        XCTAssertNil(headers["Authorization"])

        let duplicate: [HTTPHeader] = [
            .contentType(.applicationJSON),
            .contentType(.textPlain)
        ]

        XCTAssertNotNil(duplicate["Content-Type"])
        XCTAssertNotNil(duplicate["content-type"])
    }
}
