//
//  XCTest+Async.swift
//  
//
//  Created by Bram Kolkman on 26/10/2022.
//

import XCTest

extension XCTestCase {
    func XCTAssertAsyncNoThrow<T>(_ expression: @autoclosure () async throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) async {
        do {
            _ = try await expression()
        } catch {
            let message = message().isEmpty ? "" : " - \(message())"
            let context = XCTSourceCodeContext(location: XCTSourceCodeLocation(filePath: "\(file)", lineNumber: Int(line)))
            let issue = XCTIssue(
                type: .assertionFailure,
                compactDescription: "XCTAssertAsyncNoThrow failed: threw error \"\(error)\"\(message)",
                sourceCodeContext: context
            )
            self.record(issue)
        }
    }

    func XCTAssertAsyncThrowsError<T>(_ expression: @autoclosure () async throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) async {
        do {
            _ = try await expression()
            let message = message().isEmpty ? "" : " - \(message())"
            let context = XCTSourceCodeContext(location: XCTSourceCodeLocation(filePath: "\(file)", lineNumber: Int(line)))
            let issue = XCTIssue(
                type: .assertionFailure,
                compactDescription: "XCTAssertAsyncThrowsError failed: did not throw an error\(message)",
                sourceCodeContext: context
            )
            self.record(issue)
        } catch {}
    }
}
