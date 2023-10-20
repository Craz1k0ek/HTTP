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

final class URLResponseExtTests: XCTestCase {
    let url = URL("https://www.thinkerium.com")

    func testStatusCodeHTTPResponse() throws {
        let response: URLResponse = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        ))
        XCTAssertEqual(response.statusCode, .unauthorized)
    }

    func testStatusCodeURLResponse() throws {
        let response = URLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        XCTAssertEqual(response.statusCode, .ok)
    }

    func testHeadersHTTPResponse() throws {
        let response: URLResponse = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: [
                "Content-Type": "application/json",
                "Content-Length": "5"
            ]
        ))
        let headers = response.headers
        XCTAssertEqual(headers.count, 2)

        let contentType = try XCTUnwrap(headers["Content-Type"])
        XCTAssertEqual(contentType.value, MediaType.applicationJSON.rawValue)

        let contentLength = try XCTUnwrap(headers["Content-Length"])
        XCTAssertEqual(contentLength.value, "5")
    }

    func testHeadersURLResponse() throws {
        let response = URLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        XCTAssertTrue(response.headers.isEmpty)
    }

    func testTextEncodingHTTPResponse() throws {
        let unsetEncoding: URLResponse = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: [
                "Content-Type": "application/json",
                "Content-Length": "5"
            ]
        ))
        XCTAssertEqual(unsetEncoding.textEncoding, .utf8)

        let ianaUTF32 = CFStringConvertEncodingToIANACharSetName(
            CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf32.rawValue)
        ) as String
        let setEncoding: URLResponse = HTTPURLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: ianaUTF32
        )
        XCTAssertEqual(setEncoding.textEncoding, .utf32)
    }
}
