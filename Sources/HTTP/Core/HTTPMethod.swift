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

/// Methods defined to be used by HTTP.
///
/// HTTP defines a set of request methods to indicate the desired action
/// to be performed for a given resource. Each of them implements
/// a different semantic, but some common features are shared by a group
/// of them: e.g. a request method can be safe, idempotent, or cacheable.
public enum HTTPMethod: String, Sendable {
    /// The GET method requests a representation of the specified resource.
    /// Requests using GET should only retrieve data.
    case `get`
    /// The HEAD method asks for a response identical to a GET request,
    /// but without the response body.
    case head
    /// The POST method submits an entity to the specified resource,
    /// often causing a change in state or side effects on the server.
    case post
    /// The PUT method replaces all current representations of the
    /// target resource with the request payload.
    case put
    /// The DELETE method deletes the specified resource.
    case delete
    /// The CONNECT method establishes a tunnel to the server
    /// identified by the target resource.
    case connect
    /// The OPTIONS method describes the communication
    /// options for the target resource.
    case options
    /// The TRACE method performs a message loop-back test
    /// along the path to the target resource.
    case trace
    /// The PATCH method applies partial modifications to a resource.
    case patch

    public var rawValue: RawValue {
        switch self {
        case .get: return "GET"
        case .head: return "HEAD"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .connect: return "CONNECT"
        case .options: return "OPTIONS"
        case .trace: return "TRACE"
        case .patch: return "PATCH"
        }
    }

    public init?(rawValue: RawValue) {
        switch rawValue.uppercased() {
        case "GET": self = .get
        case "HEAD": self = .head
        case "POST": self = .post
        case "PUT": self = .put
        case "DELETE": self = .delete
        case "CONNECT": self = .connect
        case "OPTIONS": self = .options
        case "TRACE": self = .trace
        case "PATCH": self = .patch
        default: return nil
        }
    }
}

extension HTTPMethod: ExpressibleByStringLiteral {
    public typealias StringLiteralType = RawValue

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value.lowercased())!
    }
}

extension HTTPMethod: CustomStringConvertible {
    public var description: String { rawValue }
}

extension HTTPMethod: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
