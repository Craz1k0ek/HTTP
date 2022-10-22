//
//  HTTPMethod.swift
//  
//
//  Created by Bram Kolkman on 16/10/2022.
//

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

    public var rawValue: String {
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

    public init?(rawValue: String) {
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
    public typealias StringLiteralType = Self.RawValue

    public init(stringLiteral value: Self.StringLiteralType) {
        self.init(rawValue: value.lowercased())!
    }
}

extension HTTPMethod: CustomStringConvertible {
    public var description: String { self.rawValue }
}

extension HTTPMethod: CaseIterable {}

extension HTTPMethod: Equatable {}

extension HTTPMethod: Hashable {}
