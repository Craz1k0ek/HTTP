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

private struct TestMiddleware: RequestMiddleware {
    func process(request: inout HTTPRequest) async throws {
        request.body?.reverse()
    }
}

final class RequestMiddlewareTests: XCTestCase {
    var url: URL!
    private let middleware = TestMiddleware()

    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.thinkerium.com/"))
        try super.setUpWithError()
    }

    func testProcessRequest() async throws {
        let body = Data([0x01, 0x02, 0x03, 0x04])
        let reversed = Data([0x04, 0x03, 0x02, 0x01])
        var request = HTTPRequest(url: url, body: body)
        try await middleware.process(request: &request)

        XCTAssertEqual(reversed, request.body)
    }

    func testProcessResponse() async throws {
        let request = HTTPRequest(url: url)
        let response = HTTPResponse(originalRequest: request, statusCode: .accepted)
        try await middleware.process(response: response)
    }
}
