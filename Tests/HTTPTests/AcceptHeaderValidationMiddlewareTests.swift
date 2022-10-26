//
//  AcceptHeaderValidationMiddlewareTests.swift
//  
//
//  Created by Bram Kolkman on 26/10/2022.
//

import XCTest
@testable import HTTP

final class AcceptHeaderValidationMiddlewareTests: XCTestCase {
    let middleware = AcceptHeaderValidationMiddleware()

    func testAcceptMissing() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let request = HTTPRequest(url: url)

        let response = HTTPResponse(originalRequest: request, statusCode: .ok)

        await XCTAssertAsyncNoThrow(try await middleware.process(response: response))
    }

    func testContentTypeEmpty() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let request = HTTPRequest(url: url, headers: [
            .accept(.applicationJSON)
        ])

        let response = HTTPResponse(originalRequest: request, statusCode: .ok, headers: [
            .contentType("")
        ])

        await XCTAssertAsyncThrowsError(try await middleware.process(response: response))
    }

    func testFailure() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let request = HTTPRequest(url: url, headers: [
            .accept(.applicationJSON)
        ])

        let response = HTTPResponse(originalRequest: request, statusCode: .ok, headers: [
            .contentType(.textPlain)
        ])

        await XCTAssertAsyncThrowsError(try await middleware.process(response: response))
    }

    func testSuccess() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let request = HTTPRequest(url: url, headers: [
            .accept(.applicationJSON)
        ])

        let response = HTTPResponse(originalRequest: request, statusCode: .ok, headers: [
            .contentType(.applicationJSON)
        ])

        await XCTAssertAsyncNoThrow(try await middleware.process(response: response))
    }
}
