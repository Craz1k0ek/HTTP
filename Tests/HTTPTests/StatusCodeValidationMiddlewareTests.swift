//
//  StatusCodeValidationMiddlewareTests.swift
//  
//
//  Created by Bram Kolkman on 26/10/2022.
//

import XCTest
@testable import HTTP

fileprivate struct RequestAlteringMiddleware: Middleware {
    func process(request: inout HTTPRequest) async throws {
        request.headers.append(.authorization("admin"))
    }
}

final class StatusCodeValidationMiddlewareTests: XCTestCase {
    var client = StandardHTTPClient()

    class override func setUp() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    class override func tearDown() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    func testStatusCodeMiddlewareSuccess() async throws {
        client.middleware.append(.successOnly)

        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let body = Data("Hello world".utf8)

        URLProtocolStub.responses[url] = .success((body, .ok))
        defer { URLProtocolStub.responses.removeValue(forKey: url) }

        let request = HTTPRequest(url: url)
        do {
            _ = try await client.send(request: request)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testStatusCodeMiddlewareFailure() async throws {
        client.middleware.append(.successOnly)

        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let body = Data("Hello world".utf8)

        URLProtocolStub.responses[url] = .success((body, .badRequest))
        defer { URLProtocolStub.responses.removeValue(forKey: url) }

        let request = HTTPRequest(url: url)
        do {
            _ = try await client.send(request: request)
            XCTFail("Client is supposed to throw")
        } catch URLError.badStatusCode {
            // Correct error
        } catch {
            XCTFail("Client is supposed to URLError.badStatusCode, but threw '\(error)' instead")
        }
    }

    func testRequestAlteringMiddleware() async throws {
        client.middleware.append(RequestAlteringMiddleware())

        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let body = Data("Hello world".utf8)

        URLProtocolStub.responses[url] = .success((body, .badRequest))
        defer { URLProtocolStub.responses.removeValue(forKey: url) }

        let request = HTTPRequest(url: url)
        let response = try await client.send(request: request)
        XCTAssertTrue(response.originalRequest.headers.contains(where: { $0.name == "Authorization" }))
        XCTAssertEqual(response.originalRequest.headers.first(where: { $0.name == "Authorization" })?.value, "admin")
    }
}
