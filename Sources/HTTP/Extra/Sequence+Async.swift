//
//  Sequence+Async.swift
//  
//
//  Created by Bram Kolkman on 23/10/2022.
//

extension Sequence {
    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// Using the `asyncForEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    /// parameter.
    @inlinable func asyncForEach(_ body: (Element) async throws -> Void) async rethrows {
        for element in self {
            try await body(element)
        }
    }

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// The `updateAccumulatingResult` closure is called sequentially with a
    /// mutable accumulating value initialized to `initialResult` and each element
    /// of the sequence.
    ///
    /// If the sequence has no elements, `updateAccumulatingResult` is never
    /// executed and `initialResult` is the result of the call to
    /// `reduce(into:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating
    ///     value with an element of the sequence.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func asyncReduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) async throws -> ()) async rethrows -> Result {
        var copy = initialResult
        for element in self {
            try await updateAccumulatingResult(&copy, element)
        }
        return copy
    }
}
