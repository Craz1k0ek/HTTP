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

final class HTTPRequestExtTests: XCTestCase {
    var url: URL!

    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.thinkerium.com"))
        try super.setUpWithError()
    }

    func testConversion() {
        let httpRequest = HTTPRequest(url: url)
        let urlRequest = httpRequest.urlRequest

        XCTAssertEqual(httpRequest.url, urlRequest.url)
        XCTAssertEqual(httpRequest.method.rawValue, urlRequest.httpMethod)
        XCTAssertEqual(httpRequest.body, urlRequest.httpBody)

        let urlHeaders = httpRequest.headers.reduce(into: [String: String]()) { headers, header in
            headers[header.name] = header.value
        }
        XCTAssertEqual(urlHeaders, urlRequest.allHTTPHeaderFields ?? [:])
        XCTAssertEqual(httpRequest.timeout, urlRequest.timeoutInterval)
    }

    func testHeaderConversion() throws {
        let headers: [HTTPHeader] = [
            .contentType(.applicationJSON),
            .contentLength(5)
        ]
        let httpRequest = HTTPRequest(url: url, headers: headers)
        let urlRequest = httpRequest.urlRequest

        XCTAssertEqual(headers.count, urlRequest.allHTTPHeaderFields?.count)
        try urlRequest.allHTTPHeaderFields?.forEach { header in
            let httpHeader = try XCTUnwrap(headers[header.key])
            XCTAssertEqual(httpHeader.value, header.value)
        }
    }

    func testBodyConversion() {
        let body = Data((0 ..< 10).map { _ in UInt8.random(in: UInt8.min...UInt8.max) })
        let httpRequest = HTTPRequest(url: url, body: body)
        let urlRequest = httpRequest.urlRequest

        XCTAssertEqual(urlRequest.httpBody, body)
    }
}
