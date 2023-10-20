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

final class DataTests: XCTestCase {
    var request: HTTPRequest!

    override func setUpWithError() throws {
        let url = try XCTUnwrap(URL(string: "https://www.thinkerium.com"))
        request = HTTPRequest(url: url)
        try super.setUpWithError()
    }

    func testConvertible() {
        let response = HTTPResponse(
            originalRequest: request,
            statusCode: .ok
        )

        let data = Data.convert(from: response)
        XCTAssertEqual(data, response.body)
    }

    func testRandomBody() throws {
        let body = Data((0 ..< 10).map { _ in UInt8.random(in: UInt8.min...UInt8.max) })
        let response = HTTPResponse(
            originalRequest: request,
            statusCode: .ok,
            body: body
        )

        let data = Data.convert(from: response)
        XCTAssertEqual(data, body)
    }
}
