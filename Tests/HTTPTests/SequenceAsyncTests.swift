//
//  SequenceAsyncTests.swift
//  
//
//  Created by Bram Kolkman on 24/10/2022.
//

import XCTest
@testable import HTTP

final class SequenceAsyncTests: XCTestCase {
    fileprivate class ForEachExample {
        var number: Int

        init(_ number: Int) {
            self.number = number
        }

        func update(number: Int) async throws {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
            self.number = number
        }
    }

    func testAsyncForEach() async throws {
        let examples = (0 ..< 5).map(ForEachExample.init)
        try await examples.asyncForEach { example in
            try await example.update(number: example.number * 2)
        }
        for (index, example) in examples.enumerated() {
            XCTAssertEqual(example.number, index * 2)
        }
    }

    fileprivate struct ReduceExample {
        private var _number: Int
        var number: Int {
            get async throws {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
                return _number
            }
        }

        init(_ number: Int) {
            _number = number
        }
    }

    func testAsyncReduce() async throws {
        let examples = (0 ..< 5).map(ReduceExample.init)
        let sum = try await examples.asyncReduce(into: 0, { result, example in
            result += try await example.number
        })
        XCTAssertEqual(sum, 10)
    }
}
