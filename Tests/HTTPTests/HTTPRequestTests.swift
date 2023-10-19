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

final class HTTPRequestTests: XCTestCase {
    var url: URL!

    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.thinkerium.com/"))
        try super.setUpWithError()
    }

    func testHashable() {
        let one = HTTPRequest(url: url)
        let two = one
        let three = HTTPRequest(url: url, method: .connect)

        XCTAssertEqual(one.hashValue, two.hashValue)
        XCTAssertNotEqual(one.hashValue, three.hashValue)
    }

    func testConvertible() throws {
        let request = HTTPRequest(url: url)
        let converted = request.httpRequest
        XCTAssertEqual(request, converted)
    }
}
