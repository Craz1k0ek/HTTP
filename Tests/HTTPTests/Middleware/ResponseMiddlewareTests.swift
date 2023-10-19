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

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
private struct TestMiddleware: ResponseMiddleware {
    func process(response: HTTPResponse) async throws {
        guard response.statusCode == .accepted else {
            throw URLError(.badServerResponse)
        }
    }
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class ResponseMiddlewareTests: XCTestCase {
    var url: URL!
    private let middleware = TestMiddleware()

    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.thinkerium.com/"))
        try super.setUpWithError()
    }

    func testProcessResponse() async throws {
        let request = HTTPRequest(url: url)
        let response = HTTPResponse(originalRequest: request, statusCode: .accepted)

        try await middleware.process(response: response)

        let badRequest = HTTPResponse(originalRequest: request, statusCode: .badRequest)
        do {
            try await middleware.process(response: badRequest)
            XCTFail("Middleware was supposed to throw a URLError")
        } catch let error as URLError where error.code == .badServerResponse {}
    }

    func testProcessRequest() async throws {
        let original = HTTPRequest(url: url)
        var modified = original
        try await middleware.process(request: &modified)
        XCTAssertEqual(original, modified)
    }
}
