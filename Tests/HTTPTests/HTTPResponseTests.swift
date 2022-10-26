//
//  HTTPResponseTests.swift
//  
//
//  Created by Bram Kolkman on 22/10/2022.
//

import XCTest
@testable import HTTP

final class HTTPResponseTests: XCTestCase {
    func testInitializer() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let request = HTTPRequest(url: url)

        let statusCode = HTTPStatusCode.ok
        let headers: [HTTPHeader] = [
            .contentType(.textPlain)
        ]
        let body = Data("Hello world".utf8)
        let response = HTTPResponse(originalRequest: request, statusCode: statusCode, headers: headers, body: body)

        XCTAssertEqual(response.originalRequest, request)
        XCTAssertEqual(response.statusCode, statusCode)
        XCTAssertEqual(response.headers, headers)
        XCTAssertEqual(response.body, body)
    }

    func testInitURLResponse() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let request = HTTPRequest(url: url)

        let statusCode = HTTPStatusCode.ok
        let headers: [HTTPHeader] = [
            .contentType(.applicationJSON)
        ]
        let body = Data("Hello world".utf8)

        let urlResponse = try XCTUnwrap(
            HTTPURLResponse(url: url, statusCode: statusCode.rawValue, httpVersion: nil, headerFields: headers.reduce(into: [String: String](), { headers, header in
                headers[header.name] = header.value
            }))
        )

        let response = HTTPResponse(request: request, response: urlResponse, body: body)
        XCTAssertEqual(response.originalRequest, request)
        XCTAssertEqual(response.statusCode, statusCode)
        XCTAssertEqual(response.headers, headers)
        XCTAssertEqual(response.body, body)
    }
}

final class DecodableHTTPResponseTests: XCTestCase {
    private struct Stub: Codable {
        let someValue: String
        let anyValue: Int
    }

    func testDecoding() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let request = HTTPRequest(url: url)
        let object = Stub(someValue: #function, anyValue: #line)

        let body = try JSONEncoder().encode(object)
        let response = HTTPResponse(originalRequest: request, statusCode: .ok, body: body)

        let decodable = try response.decode(to: Stub.self)
        XCTAssertEqual(object.someValue, decodable.someValue)
        XCTAssertEqual(object.anyValue, decodable.anyValue)
    }

    func testDecodingWithDecoder() throws {
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let request = HTTPRequest(url: url)
        let object = Stub(someValue: #function, anyValue: #line)

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try JSONEncoder().encode(object)
        let response = HTTPResponse(originalRequest: request, statusCode: .ok, body: body)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodable = try response.decode(to: Stub.self)
        XCTAssertEqual(object.someValue, decodable.someValue)
        XCTAssertEqual(object.anyValue, decodable.anyValue)
    }
}
