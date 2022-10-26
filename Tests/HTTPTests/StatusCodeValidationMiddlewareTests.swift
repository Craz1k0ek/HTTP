//
//  StatusCodeValidationMiddlewareTests.swift
//  
//
//  Created by Bram Kolkman on 26/10/2022.
//

import XCTest
@testable import HTTP

final class StatusCodeValidationMiddlewareTests: XCTestCase {
    let middleware = StatusCodeValidationMiddleware.successOnly

    func testSuccess() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let request = HTTPRequest(url: url)

        let response = HTTPResponse(originalRequest: request, statusCode: .ok)
        await XCTAssertAsyncNoThrow(try await middleware.process(response: response))
    }

    func testFailure() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let request = HTTPRequest(url: url)

        let response = HTTPResponse(originalRequest: request, statusCode: .badRequest)
        await XCTAssertAsyncThrowsError(try await middleware.process(response: response))
    }
}
