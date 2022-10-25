//
//  StandardHTTPClientTests.swift
//  
//
//  Created by Bram Kolkman on 24/10/2022.
//

import XCTest
@testable import HTTP

final class StandardHTTPClientTests: XCTestCase {
    var client = StandardHTTPClient()

    override class func setUp() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    func testSuccessResponse() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        let body = Data("Hello world".utf8)

        URLProtocolStub.responses[url] = .success((body, .ok))
        defer { URLProtocolStub.responses.removeValue(forKey: url) }

        let request = HTTPRequest(url: url)
        let response = try await client.send(request: request)

        XCTAssertEqual(response.body, body)
    }

    func testFailedResponse() async throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))

        URLProtocolStub.responses[url] = .failure(CocoaError(.fileNoSuchFile))
        defer { URLProtocolStub.responses.removeValue(forKey: url) }

        let request = HTTPRequest(url: url)
        do {
            _ = try await client.send(request: request)
            XCTFail("Client is supposed to throw")
        } catch {}
    }
}

final class ExtraStandardHTTPClientTests: XCTestCase {
    let client = StandardHTTPClient()

    override class func setUp() {
        URLProtocol.registerClass(URLResponseStub.self)
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(URLResponseStub.self)
    }

    func testURLResponseFailure() async throws {
        URLProtocol.registerClass(URLResponseStub.self)
        defer { URLProtocol.unregisterClass(URLResponseStub.self) }

        let url = try XCTUnwrap(URL(string: "https://www.example.com/\(#function)"))
        URLResponseStub.urls.append(url)
        defer { URLResponseStub.urls.removeAll(where: { $0 == url } )}

        let request = HTTPRequest(url: url)
        do {
            _ = try await client.send(request: request)
            XCTFail("Client is supposed to throw")
        } catch {}
    }
}
