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

/// A type used to process incoming HTTP responses.
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public protocol ResponseMiddleware: Middleware {
    /// Process a response.
    /// - Parameter response: The HTTP response to process.
    func process(response: HTTPResponse) async throws
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension ResponseMiddleware {
    public func process(request: inout HTTPRequest) async throws {}
}
