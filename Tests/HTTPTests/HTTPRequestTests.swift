//
//  HTTPRequestTests.swift
//  
//
//  Created by Bram Kolkman on 22/10/2022.
//

import XCTest
@testable import HTTP

final class HTTPRequestTests: XCTestCase {
    func testInitializer() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let method = HTTPMethod.post
        let headers: [HTTPHeader] = [
            .accept(.textPlain)
        ]
        let body = Data("Hello world".utf8)
        let timeout: TimeInterval = 50

        let request = HTTPRequest(url: url, method: method, headers: headers, body: body, timeout: timeout)
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.body, body)
        XCTAssertEqual(request.timeout, timeout)
    }

    func testInitWithDefaults() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let request = HTTPRequest(url: url)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, .get)
        XCTAssertTrue(request.headers.isEmpty)
        XCTAssertNil(request.body)
        XCTAssertEqual(request.timeout, 60)
    }

    func testInitURLRequest() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let method = HTTPMethod.post
        let headers: [HTTPHeader] = [
            .accept(.textPlain)
        ]
        let body = Data("Hello world".utf8)
        let timeout: TimeInterval = 50

        var urlRequest = URLRequest(url: url, timeoutInterval: timeout)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.reduce(into: [String: String](), { headers, header in
            headers[header.name] = header.value
        })
        urlRequest.httpBody = body

        let request = try XCTUnwrap(HTTPRequest(request: urlRequest))
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.body, body)
        XCTAssertEqual(request.timeout, timeout)
    }

    func testInitURLRequestWithoutURL() throws {
        let urlRequest = NSURLRequest() as URLRequest
        XCTAssertNil(HTTPRequest(request: urlRequest))
    }

    func testInitURLRequestWithoutMethod() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = nil
        let request = try XCTUnwrap(HTTPRequest(request: urlRequest))
        XCTAssertEqual(request.method, .get)
    }

    func testInitURLRequestWithInvalidMethod() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = UUID().uuidString
        let request = try XCTUnwrap(HTTPRequest(request: urlRequest))
        XCTAssertEqual(request.method, .get)
    }

    func testURLRequestExport() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let method = HTTPMethod.post
        let headers: [HTTPHeader] = [
            .accept(.textPlain)
        ]
        let body = Data("Hello world".utf8)
        let timeout: TimeInterval = 50

        let request = HTTPRequest(url: url, method: method, headers: headers, body: body, timeout: timeout)
        let urlRequest = request.urlRequest

        XCTAssertEqual(urlRequest.url, url)
        XCTAssertEqual(urlRequest.httpMethod, method.rawValue)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, headers.reduce(into: [String: String](), { headers, header in
            headers[header.name] = header.value
        }))
        XCTAssertEqual(urlRequest.httpBody, body)
        XCTAssertEqual(urlRequest.timeoutInterval, timeout)
    }
}
