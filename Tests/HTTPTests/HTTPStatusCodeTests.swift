//
//  HTTPStatusCodeTests.swift
//  
//
//  Created by Bram Kolkman on 16/10/2022.
//

import XCTest
@testable import HTTP

final class HTTPStatusCodeTests: XCTestCase {
    let tests: [(Int, HTTPStatusCode)] = [
        (100, .continue),
        (101, .switchingProtocols),
        (200, .ok),
        (201, .created),
        (202, .accepted),
        (203, .nonAuthoritativeInformation),
        (204, .noContent),
        (205, .resetContent),
        (206, .partialContent),
        (300, .multipleChoices),
        (301, .movedPermanently),
        (302, .found),
        (303, .seeOther),
        (304, .notModified),
        (305, .useProxy),
        (306, .switchProxy),
        (307, .temporaryRedirect),
        (308, .permanentRedirect),
        (400, .badRequest),
        (401, .unauthorized),
        (402, .paymentRequired),
        (403, .forbidden),
        (404, .notFound),
        (405, .methodNotAllowed),
        (406, .notAcceptable),
        (407, .proxyAuthenticationRequired),
        (408, .requestTimeout),
        (409, .conflict),
        (410, .gone),
        (411, .lengthRequired),
        (412, .preconditionFailed),
        (413, .contentTooLarge),
        (414, .uriTooLong),
        (415, .unsupportedMediaType),
        (416, .rangeNotSatisfiable),
        (417, .expectationFailed),
        (418, .teapot),
        (421, .misdirectedRequest),
        (422, .unprocessableContent),
        (426, .upgradeRequired),
        (500, .internalServerError),
        (501, .notImplemented),
        (502, .badGateway),
        (503, .serviceUnavailable),
        (504, .gatewayTimeout),
        (505, .httpVersionNotSupported),
        (108, .custom(108))
    ]
    
    func testRawValues() {
        for test in tests {
            XCTAssertEqual(test.0, test.1.rawValue)
        }
        
        let custom: (Int, HTTPStatusCode) = (108, .custom(108))
        XCTAssertEqual(custom.0, custom.1.rawValue)
    }
    
    func testRawValueInitializer() throws {
        for test in tests {
            let created = try XCTUnwrap(HTTPStatusCode(rawValue: test.0))
            XCTAssertEqual(created, test.1)
        }
    }
    
    func testIntegerExpressible() throws {
        for test in tests {
            let code = HTTPStatusCode(integerLiteral: test.0)
            XCTAssertEqual(code, test.1)
        }
    }
}
