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

final class HTTPStatusCodeTests: XCTestCase {
    let tests: [(Int, HTTPStatusCode, String)] = [
        (100, .continue, "100 Continue"),
        (101, .switchingProtocols, "101 Switching Protocols"),
        (200, .ok, "200 OK"),
        (201, .created, "201 Created"),
        (202, .accepted, "202 Accepted"),
        (203, .nonAuthoritativeInformation, "203 Non-Authoritative Information"),
        (204, .noContent, "204 No Content"),
        (205, .resetContent, "205 Reset Content"),
        (206, .partialContent, "206 Partial Content"),
        (300, .multipleChoices, "300 Multiple Choices"),
        (301, .movedPermanently, "301 Moved Permanently"),
        (302, .found, "302 Found"),
        (303, .seeOther, "303 See Other"),
        (304, .notModified, "304 Not Modified"),
        (305, .useProxy, "305 Use Proxy"),
        (306, .switchProxy, "306 Switch Proxy"),
        (307, .temporaryRedirect, "307 Temporary Redirect"),
        (308, .permanentRedirect, "308 Permanent Redirect"),
        (400, .badRequest, "400 Bad Request"),
        (401, .unauthorized, "401 Unauthorized"),
        (402, .paymentRequired, "402 Payment Required"),
        (403, .forbidden, "403 Forbidden"),
        (404, .notFound, "404 Not Found"),
        (405, .methodNotAllowed, "405 Method Not Allowed"),
        (406, .notAcceptable, "406 Not Acceptable"),
        (407, .proxyAuthenticationRequired, "407 Proxy Authentication Required"),
        (408, .requestTimeout, "408 Request Timeout"),
        (409, .conflict, "409 Conflict"),
        (410, .gone, "410 Gone"),
        (411, .lengthRequired, "411 Length Required"),
        (412, .preconditionFailed, "412 Precondition Failed"),
        (413, .contentTooLarge, "413 Content Too Large"),
        (414, .uriTooLong, "414 URI Too Long"),
        (415, .unsupportedMediaType, "415 Unsupported Media Type"),
        (416, .rangeNotSatisfiable, "416 Range Not Satisfiable"),
        (417, .expectationFailed, "417 Expectation Failed"),
        (418, .teapot, "418 I'm a teapot"),
        (421, .misdirectedRequest, "421 Misdirected Request"),
        (422, .unprocessableContent, "422 Unprocessable Content"),
        (426, .upgradeRequired, "426 Upgrade Required"),
        (500, .internalServerError, "500 Internal Server Error"),
        (501, .notImplemented, "501 Not Implemented"),
        (502, .badGateway, "502 Bad Gateway"),
        (503, .serviceUnavailable, "503 Service Unavailable"),
        (504, .gatewayTimeout, "504 Gateway Timeout"),
        (505, .httpVersionNotSupported, "505 HTTP Version Not Supported"),
        (600, .custom(600), "600 Custom")
    ]

    func testRawValues() {
        for test in tests {
            XCTAssertEqual(test.0, test.1.rawValue)
        }

        let custom: (Int, HTTPStatusCode) = (108, .custom(108))
        XCTAssertEqual(custom.0, custom.1.rawValue)
    }

    func testRawValueInitializer() throws {
        for test in tests {
            let created = try XCTUnwrap(HTTPStatusCode(rawValue: test.0))
            XCTAssertEqual(created, test.1)
        }
    }

    func testIntegerExpressible() throws {
        for test in tests {
            let code = HTTPStatusCode(integerLiteral: test.0)
            XCTAssertEqual(code, test.1)
        }
    }

    func testDescription() {
        for test in tests {
            XCTAssertEqual(test.2, test.1.description)
        }
    }

    func testComparable() {
        for (index, test) in tests.enumerated() {
            if index > 0 {
                XCTAssertTrue(tests[index - 1].1 < test.1)
                XCTAssertTrue(tests[index - 1].1 <= test.1)
                XCTAssertFalse(tests[index - 1].1 == test.1)
                XCTAssertTrue(test.1 > tests[index - 1].1)
                XCTAssertTrue(test.1 >= tests[index - 1].1)
            }

            XCTAssertTrue(tests[index].1 == test.1)
            XCTAssertTrue(tests[index].1 >= test.1)
            XCTAssertTrue(tests[index].1 <= test.1)
            XCTAssertFalse(tests[index].1 < test.1)
            XCTAssertFalse(tests[index].1 > test.1)

            if index < tests.count - 1 {
                XCTAssertTrue(tests[index + 1].1 > test.1)
                XCTAssertTrue(tests[index + 1].1 >= test.1)
                XCTAssertFalse(tests[index + 1].1 == test.1)
                XCTAssertTrue(test.1 < tests[index + 1].1)
                XCTAssertTrue(test.1 <= tests[index + 1].1)
            }
        }
    }
}
