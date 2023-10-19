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
        tests.forEach { test in
            XCTAssertEqual(test.0, test.1.rawValue)
            XCTAssertEqual(test.1.rawValue, test.0)
        }
    }

    func testMultipartEmptyBoundary() {
        let multipart = MediaType.multipartFormData(boundary: "")
        XCTAssertEqual(multipart, .multipartFormData)
    }

    func testMultipartWhitespacedBoundary() {
        let multipart = MediaType.multipartFormData(boundary: "     ")
        XCTAssertEqual(multipart, .multipartFormData)
    }

    func testHashable() {
        tests.forEach { test in
            let mediaType = test.1
            let constructed = MediaType(rawValue: test.0)

            XCTAssertEqual(mediaType.hashValue, constructed.hashValue)
        }
    }
}
