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

final class HTTPMethodTests: XCTestCase {
    let methods: [HTTPMethod] = [
        .get,
        .head,
        .post,
        .put,
        .delete,
        .connect,
        .options,
        .trace,
        .patch
    ]

    func testRawValues() {
        for method in methods {
            XCTAssertEqual("\(method)".uppercased(), method.rawValue)
        }
    }

    func testRawValueInitializer() throws {
        for method in methods {
            let uppercased = try XCTUnwrap(HTTPMethod(rawValue: method.rawValue))
            let lowercased = try XCTUnwrap(HTTPMethod(rawValue: method.rawValue.lowercased()))

            XCTAssertEqual(uppercased, method)
            XCTAssertEqual(lowercased, method)
        }
    }

    func testInvalidRawValueInitializer() {
        XCTAssertNil(HTTPMethod(rawValue: #function))
    }

    func testStringExpressible() throws {
        let upper = ["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
        let lower = ["get", "head", "post", "put", "delete", "connect", "options", "trace", "patch"]
        let methods: [HTTPMethod] = [.get, .head, .post, .put, .delete, .connect, .options, .trace, .patch]

        for (string, method) in zip(zip(upper, lower), methods) {
            let lower: HTTPMethod = HTTPMethod(stringLiteral: "\(string.0)")
            let upper: HTTPMethod = HTTPMethod(stringLiteral: "\(string.1)")
            XCTAssertEqual(lower, method)
            XCTAssertEqual(upper, method)
        }
    }
}
