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

@testable import HTTPExtra
import HTTP
import XCTest

final class StringTests: XCTestCase {
    var request: HTTPRequest!

    override func setUpWithError() throws {
        let url = try XCTUnwrap(URL(string: "https://www.thinkerium.com"))
        request = HTTPRequest(url: url)
        try super.setUpWithError()
    }

    func testConvertible() throws {
        let value = UUID().uuidString
        let response = HTTPResponse(
            originalRequest: request,
            statusCode: .ok,
            body: Data(value.utf8)
        )

        let string = try String.convert(from: response)
        XCTAssertEqual(string, value)
    }

    func testConvertibleEncoding() throws {
        let value = UUID().uuidString

        let tests: [String.Encoding: Data] = try {
            var tests = [String.Encoding: Data]()

            tests[.ascii] = try XCTUnwrap(value.data(using: .ascii))
            tests[.nextstep] = try XCTUnwrap(value.data(using: .nextstep))
            tests[.japaneseEUC] = try XCTUnwrap(value.data(using: .japaneseEUC))
            tests[.utf8] = try XCTUnwrap(value.data(using: .utf8))
            tests[.isoLatin1] = try XCTUnwrap(value.data(using: .isoLatin1))
            tests[.nonLossyASCII] = try XCTUnwrap(value.data(using: .nonLossyASCII))
            tests[.shiftJIS] = try XCTUnwrap(value.data(using: .shiftJIS))
            tests[.isoLatin2] = try XCTUnwrap(value.data(using: .isoLatin2))
            tests[.unicode] = try XCTUnwrap(value.data(using: .unicode))
            tests[.windowsCP1251] = try XCTUnwrap(value.data(using: .windowsCP1251))
            tests[.windowsCP1252] = try XCTUnwrap(value.data(using: .windowsCP1252))
            tests[.windowsCP1253] = try XCTUnwrap(value.data(using: .windowsCP1253))
            tests[.windowsCP1254] = try XCTUnwrap(value.data(using: .windowsCP1254))
            tests[.windowsCP1250] = try XCTUnwrap(value.data(using: .windowsCP1250))
            tests[.iso2022JP] = try XCTUnwrap(value.data(using: .iso2022JP))
            tests[.macOSRoman] = try XCTUnwrap(value.data(using: .macOSRoman))
            tests[.utf16] = try XCTUnwrap(value.data(using: .utf16))
            tests[.utf16BigEndian] = try XCTUnwrap(value.data(using: .utf16BigEndian))
            tests[.utf16LittleEndian] = try XCTUnwrap(value.data(using: .utf16LittleEndian))
            tests[.utf32] = try XCTUnwrap(value.data(using: .utf32))
            tests[.utf32BigEndian] = try XCTUnwrap(value.data(using: .utf32BigEndian))
            tests[.utf32LittleEndian] = try XCTUnwrap(value.data(using: .utf32LittleEndian))

            return tests
        }()

        try tests.forEach { test in
            let response = HTTPResponse(
                originalRequest: request,
                statusCode: .ok,
                body: test.value,
                textEncoding: test.key
            )

            let string = try String.convert(from: response)
            XCTAssertEqual(string, value)
        }
    }

    func testInvalidEncoding() throws {
        let value = UUID().uuidString
        let body = try XCTUnwrap(value.data(using: .utf16))

        let response = HTTPResponse(
            originalRequest: request,
            statusCode: .ok,
            body: body,
            textEncoding: .utf8
        )

        XCTAssertThrowsError(try String.convert(from: response))
    }
}
