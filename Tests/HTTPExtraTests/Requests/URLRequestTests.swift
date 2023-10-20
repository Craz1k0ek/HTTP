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

@testable import HTTPExtra
import HTTP
import XCTest

final class URLRequestTests: XCTestCase {
    var url: URL!

    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.thinkerium.com"))
        try super.setUpWithError()
    }

    func testConvertible() throws {
        let urlRequest = URLRequest(url: url)
        let request = try urlRequest.httpRequest

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.timeout, 60)
        XCTAssertTrue(request.headers.isEmpty)
        XCTAssertNil(request.body)
    }

    func testMethodConvertible() throws {
        let methods: [HTTPMethod] = [
            .get, .head, .post, .put, .delete,
            .connect, .options, .trace, .patch
        ]

        try methods.forEach { method in
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            let request = try urlRequest.httpRequest

            XCTAssertEqual(request.method, method)
        }
    }

    func testInvalidHTTPMethod() throws {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = UUID().uuidString
        let request = try urlRequest.httpRequest

        XCTAssertEqual(request.method, .get)
    }

    func testHeaders() throws {
        let tests: [[HTTPHeader]] = [
            [],
            [.contentType(.applicationJSON)],
            [.contentType(.applicationJSON), .contentLength(5)]
        ]

        try tests.forEach { headers in
            var urlRequest = URLRequest(url: url)
            headers.forEach { header in
                urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
            }
            let request = try urlRequest.httpRequest

            headers.forEach { header in
                XCTAssertTrue(request.headers.contains(header))
            }
        }
    }

    func testDuplicateHeader() throws {
        var urlRequest = URLRequest(url: url)
        let value = UUID().uuidString
        urlRequest.setValue(UUID().uuidString, forHTTPHeaderField: #function)
        urlRequest.setValue(value, forHTTPHeaderField: #function)
        let request = try urlRequest.httpRequest

        let header = try XCTUnwrap(request.headers[#function])
        XCTAssertEqual(header.value, value)
    }

    func testBody() throws {
        let body = Data((0 ..< 10).map { _ in UInt8.random(in: UInt8.min...UInt8.max) })
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = body
        let request = try urlRequest.httpRequest

        XCTAssertEqual(request.body, body)
    }

    func testTimeoutInterval() throws {
        let timeouts = (0 ..< 10).map { _ in TimeInterval(UInt64.random(in: UInt64.min...UInt64.max)) }

        try timeouts.forEach { timeout in
            let urlRequest = URLRequest(url: url, timeoutInterval: timeout)
            let request = try urlRequest.httpRequest

            XCTAssertEqual(request.timeout, timeout)
        }
    }
}
