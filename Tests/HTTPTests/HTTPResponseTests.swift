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

final class HTTPResponseTests: XCTestCase {
    var request: HTTPRequest!

    override func setUpWithError() throws {
        let url = try XCTUnwrap(URL(string: "https://www.thinkerium.com/"))
        request = HTTPRequest(url: url)
        try super.setUpWithError()
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testDecode() throws {
        let string = "Hello, world"
        let body = try JSONEncoder().encode(string)
        let response = HTTPResponse(originalRequest: request, statusCode: .ok, body: body)
        let decoded = try response.decode(to: String.self, using: JSONDecoder())
        XCTAssertEqual(string, decoded)
    }

    func testHashable() {
        let one = HTTPResponse(originalRequest: request, statusCode: .ok, body: Data())
        let two = one
        let three = HTTPResponse(originalRequest: request, statusCode: .ok, body: Data([0x01, 0x02]))

        XCTAssertEqual(one.hashValue, two.hashValue)
        XCTAssertNotEqual(one.hashValue, three.hashValue)
    }

    func testConvertible() throws {
        let response = HTTPResponse(originalRequest: request, statusCode: .ok, body: Data())
        let converted = try HTTPResponse.convert(from: response)
        XCTAssertEqual(response, converted)
    }
}
