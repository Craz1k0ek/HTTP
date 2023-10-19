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

/// Status codes defined to be used by HTTP.
///
/// HTTP response status codes indicate whether a specific HTTP request has
/// been successfully completed.
///
/// Responses are grouped in five classes:
/// 1. Informational responses (100 - 199)
/// 2. Successful responses (200 - 299)
/// 3. Redirection messages (300 - 399)
/// 4. Client error responses (400 - 499)
/// 5. Server error responses (500 - 599)
///
/// The `HTTPStatusCode` class lists all status codes defined by
/// [RFC 9110](https://httpwg.org/specs/rfc9110.html#overview.of.status.codes).
///
/// A response not listed below is considered a non standard response,
/// possibly custom to the server's software. It's defined as `.custom`.
public enum HTTPStatusCode: RawRepresentable, Sendable {
    public typealias RawValue = Int

    /// This interim response indicates that the client should continue
    /// the request or ignore the response if the request is already finished.
    case `continue`
    /// This code is sent in response to an _Upgrade_ request header
    /// from the client and indicates the protocol the server is switching to.
    case switchingProtocols

    /// The request succeeded.
    ///
    /// The result meaning of "success" depends on the HTTP method:
    /// - GET: The resource has been fetched and transmitted in the message body.
    /// - HEAD: The representation headers are included in the response without any message body.
    /// - PUT or POST: The resource describing the result of the action is transmitted in the message body.
    /// - TRACE: The message body contains the request message as received by the server.
    case ok
    /// The request succeeded, and a new resource was created as a result.
    ///
    /// This is typically the response sent after POST requests, or some PUT requests.
    case created
    /// The request has been received but not yet acted upon.
    ///
    /// It is noncommittal, since there is no way in HTTP to later send an asynchronous response indicating
    /// the outcome of the request. It is intended for cases where another process
    /// or server handles the request, or for batch processing.
    case accepted
    /// This response code means the returned metadata is not exactly the same
    /// as is available from the origin server, but is collected from a local or a third-party copy.
    ///
    /// This is mostly used for mirrors or backups of another resource.
    /// Except for that specific case, the `200 OK` response is preferred to this status.
    case nonAuthoritativeInformation
    /// There is no content to send for this request, but the headers may be useful.
    /// The user agent may update its cached headers for this resource with the new ones.
    case noContent
    /// Tells the user agent to reset the document which sent this request.
    case resetContent
    /// This response code is used when the _Range_ header is sent from the
    /// client to request only part of a resource.
    case partialContent

    /// The request has more than one possible response.
    /// The user agent or user should choose one of them.
    ///
    /// There is no standardized way of choosing one of the responses,
    /// but HTML links to the possibilities are recommended so the user can pick.
    case multipleChoices
    /// The URL of the requested resource has been changed permanently.
    /// The new URL is given in the response.
    case movedPermanently
    /// This response code means that the URI of requested resource has
    /// been changed temporarily. Further changes in the URI might be made in the future.
    /// Therefore, this same URI should be used by the client in future requests.
    case found
    /// The server sent this response to direct the client to get the requested
    /// resource at another URI with a GET request.
    case seeOther
    /// This is used for caching purposes. It tells the client that the response has not been modified,
    /// so the client can continue to use the same cached version of the response.
    case notModified
    /// Defined in a previous version of the HTTP specification to indicate that a requested
    /// response must be accessed by a proxy.
    ///
    /// It has been deprecated due to security concerns regarding in-band configuration of a proxy.
    case useProxy
    /// This response code is no longer used; it is just reserved.
    ///
    /// It was used in a previous version of the HTTP/1.1 specification.
    case switchProxy
    /// The server sends this response to direct the client to get the requested resource at another
    /// URI with same method that was used in the prior request.
    ///
    /// This has the same semantics as the `302 Found` HTTP response code,
    /// with the exception that the user agent must not change the HTTP method used:
    /// if a `POST` was used in the first request, a `POST` must be used in the second request.
    case temporaryRedirect
    /// This means that the resource is now permanently located at another URI,
    /// specified by the _Location_: HTTP Response header.
    ///
    /// This has the same semantics as the `301 Moved Permanently` HTTP response code,
    /// with the exception that the user agent must not change the HTTP method used:
    /// if a `POST` was used in the first request, a `POST` must be used in the second request.
    case permanentRedirect

    /// The server cannot or will not process the request due to something that is perceived to be a
    /// client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing).
    case badRequest
    /// Although the HTTP standard specifies "unauthorized", semantically this response means "unauthenticated".
    /// That is, the client must authenticate itself to get the requested response.
    case unauthorized
    /// This response code is reserved for future use.
    ///
    /// The initial aim for creating this code was using it for digital payment systems,
    /// however this status code is used very rarely and no standard convention exists.
    case paymentRequired
    /// The client does not have access rights to the content; that is, it is unauthorized,
    /// so the server is refusing to give the requested resource.
    ///
    /// Unlike `401 Unauthorized`, the client's identity is known to the server.
    case forbidden
    /// The server can not find the requested resource.
    ///
    /// In the browser, this means the URL is not recognized.
    /// In an API, this can also mean that the endpoint is valid but the resource itself does not exist.
    /// Servers may also send this response instead of `403 Forbidden` to hide the existence
    /// of a resource from an unauthorized client. This response code is probably the most well
    /// known due to its frequent occurrence on the web.
    case notFound
    /// The request method is known by the server but is not supported by the target resource.
    ///
    /// For example, an API may not allow calling `DELETE` to remove a resource.
    case methodNotAllowed
    /// This response is sent when the web server, after performing server-driven content negotiation,
    ///  doesn't find any content that conforms to the criteria given by the user agent.
    case notAcceptable
    /// This is similar to `401 Unauthorized` but authentication is needed to be done by a proxy.
    case proxyAuthenticationRequired
    /// This response is sent on an idle connection by some servers, even without any previous
    /// request by the client.
    ///
    /// It means that the server would like to shut down this unused connection.
    /// This response is used much more since some browsers, like Chrome, Firefox 27+, or IE9,
    /// use HTTP pre-connection mechanisms to speed up surfing.
    /// Also note that some servers merely shut down the connection without sending this message.
    case requestTimeout
    /// This response is sent when a request conflicts with the current state of the server.
    case conflict
    /// This response is sent when the requested content has been permanently deleted
    /// from server, with no forwarding address.
    ///
    /// Clients are expected to remove their caches and links to the resource.
    /// The HTTP specification intends this status code to be used for "limited-time, promotional services".
    /// APIs should not feel compelled to indicate resources that have been deleted with this status code.
    case gone
    /// Server rejected the request because the _Content-Length_ header field
    /// is not defined and the server requires it.
    case lengthRequired
    /// The client has indicated preconditions in its headers which the server does not meet.
    case preconditionFailed
    /// Request entity is larger than limits defined by server.
    ///
    /// The server might close the connection or return a _Retry-After_ header field.
    case contentTooLarge
    /// The URI requested by the client is longer than the server is willing to interpret.
    case uriTooLong
    /// The media format of the requested data is not supported by the server,
    /// so the server is rejecting the request.
    case unsupportedMediaType
    /// The range specified by the _Range_ header field in the request cannot be fulfilled.
    ///
    /// It's possible that the range is outside the size of the target URI's data.
    case rangeNotSatisfiable
    /// This response code means the expectation indicated by the _Expect_
    /// request header field cannot be met by the server.
    case expectationFailed
    /// The server refuses the attempt to brew coffee with a teapot.
    case teapot
    /// The request was directed at a server that is not able to produce a response.
    ///
    /// This can be sent by a server that is not configured to produce responses for
    /// the combination of scheme and authority that are included in the request URI.
    case misdirectedRequest
    /// The request was well-formed but was unable to be followed due to semantic errors.
    case unprocessableContent
    /// The server refuses to perform the request using the current protocol but might
    /// be willing to do so after the client upgrades to a different protocol.
    ///
    /// The server sends an _Upgrade_ header in a 426 response to indicate the required protocol(s).
    case upgradeRequired

    /// The server has encountered a situation it does not know how to handle.
    case internalServerError
    /// The request method is not supported by the server and cannot be handled.
    ///
    /// The only methods that servers are required to support
    /// (and therefore that must not return this code) are `GET` and `HEAD`.
    case notImplemented
    /// This error response means that the server, while working as a gateway to
    /// get a response needed to handle the request, got an invalid response.
    case badGateway
    /// The server is not ready to handle the request.
    ///
    /// Common causes are a server that is down for maintenance or that is overloaded.
    /// Note that together with this response, a user-friendly page explaining the problem should be sent.
    /// This response should be used for temporary conditions and the _Retry-After_ HTTP header should,
    /// if possible, contain the estimated time before the recovery of the service.
    /// The webmaster must also take care about the caching-related headers that are sent along with this response,
    /// as these temporary condition responses should usually not be cached.
    case serviceUnavailable
    /// This error response is given when the server is acting as a gateway and cannot get a response in time.
    case gatewayTimeout
    /// The HTTP version used in the request is not supported by the server.
    case httpVersionNotSupported

    /// A non-standard response, possibly custom to the server's software.
    case custom(RawValue)

    public init(rawValue: RawValue) {
        switch rawValue {
        case 100: self = .continue
        case 101: self = .switchingProtocols

        case 200: self = .ok
        case 201: self = .created
        case 202: self = .accepted
        case 203: self = .nonAuthoritativeInformation
        case 204: self = .noContent
        case 205: self = .resetContent
        case 206: self = .partialContent

        case 300: self = .multipleChoices
        case 301: self = .movedPermanently
        case 302: self = .found
        case 303: self = .seeOther
        case 304: self = .notModified
        case 305: self = .useProxy
        case 306: self = .switchProxy
        case 307: self = .temporaryRedirect
        case 308: self = .permanentRedirect

        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 402: self = .paymentRequired
        case 403: self = .forbidden
        case 404: self = .notFound
        case 405: self = .methodNotAllowed
        case 406: self = .notAcceptable
        case 407: self = .proxyAuthenticationRequired
        case 408: self = .requestTimeout
        case 409: self = .conflict
        case 410: self = .gone
        case 411: self = .lengthRequired
        case 412: self = .preconditionFailed
        case 413: self = .contentTooLarge
        case 414: self = .uriTooLong
        case 415: self = .unsupportedMediaType
        case 416: self = .rangeNotSatisfiable
        case 417: self = .expectationFailed
        case 418: self = .teapot
        case 421: self = .misdirectedRequest
        case 422: self = .unprocessableContent
        case 426: self = .upgradeRequired

        case 500: self = .internalServerError
        case 501: self = .notImplemented
        case 502: self = .badGateway
        case 503: self = .serviceUnavailable
        case 504: self = .gatewayTimeout
        case 505: self = .httpVersionNotSupported
        default:
            self = .custom(rawValue)
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .`continue`: return 100
        case .switchingProtocols: return 101

        case .ok: return 200
        case .created: return 201
        case .accepted: return 202
        case .nonAuthoritativeInformation: return 203
        case .noContent: return 204
        case .resetContent: return 205
        case .partialContent: return 206

        case .multipleChoices: return 300
        case .movedPermanently: return 301
        case .found: return 302
        case .seeOther: return 303
        case .notModified: return 304
        case .useProxy: return 305
        case .switchProxy: return 306
        case .temporaryRedirect: return 307
        case .permanentRedirect: return 308

        case .badRequest: return 400
        case .unauthorized: return 401
        case .paymentRequired: return 402
        case .forbidden: return 403
        case .notFound: return 404
        case .methodNotAllowed: return 405
        case .notAcceptable: return 406
        case .proxyAuthenticationRequired: return 407
        case .requestTimeout: return 408
        case .conflict: return 409
        case .gone: return 410
        case .lengthRequired: return 411
        case .preconditionFailed: return 412
        case .contentTooLarge: return 413
        case .uriTooLong: return 414
        case .unsupportedMediaType: return 415
        case .rangeNotSatisfiable: return 416
        case .expectationFailed: return 417
        case .teapot: return 418
        case .misdirectedRequest: return 421
        case .unprocessableContent: return 422
        case .upgradeRequired: return 426

        case .internalServerError: return 500
        case .notImplemented: return 501
        case .badGateway: return 502
        case .serviceUnavailable: return 503
        case .gatewayTimeout: return 504
        case .httpVersionNotSupported: return 505
        case .custom(let code): return code
        }
    }
}

extension HTTPStatusCode: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = RawValue

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)
    }
}

extension HTTPStatusCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .`continue`: return "100 Continue"
        case .switchingProtocols: return "101 Switching Protocols"

        case .ok: return "200 OK"
        case .created: return "201 Created"
        case .accepted: return "202 Accepted"
        case .nonAuthoritativeInformation: return "203 Non-Authoritative Information"
        case .noContent: return "204 No Content"
        case .resetContent: return "205 Reset Content"
        case .partialContent: return "206 Partial Content"

        case .multipleChoices: return "300 Multiple Choices"
        case .movedPermanently: return "301 Moved Permanently"
        case .found: return "302 Found"
        case .seeOther: return "303 See Other"
        case .notModified: return "304 Not Modified"
        case .useProxy: return "305 Use Proxy"
        case .switchProxy: return "306 Switch Proxy"
        case .temporaryRedirect: return "307 Temporary Redirect"
        case .permanentRedirect: return "308 Permanent Redirect"

        case .badRequest: return "400 Bad Request"
        case .unauthorized: return "401 Unauthorized"
        case .paymentRequired: return "402 Payment Required"
        case .forbidden: return "403 Forbidden"
        case .notFound: return "404 Not Found"
        case .methodNotAllowed: return "405 Method Not Allowed"
        case .notAcceptable: return "406 Not Acceptable"
        case .proxyAuthenticationRequired: return "407 Proxy Authentication Required"
        case .requestTimeout: return "408 Request Timeout"
        case .conflict: return "409 Conflict"
        case .gone: return "410 Gone"
        case .lengthRequired: return "411 Length Required"
        case .preconditionFailed: return "412 Precondition Failed"
        case .contentTooLarge: return "413 Content Too Large"
        case .uriTooLong: return "414 URI Too Long"
        case .unsupportedMediaType: return "415 Unsupported Media Type"
        case .rangeNotSatisfiable: return "416 Range Not Satisfiable"
        case .expectationFailed: return "417 Expectation Failed"
        case .teapot: return "418 I'm a teapot"
        case .misdirectedRequest: return "421 Misdirected Request"
        case .unprocessableContent: return "422 Unprocessable Content"
        case .upgradeRequired: return "426 Upgrade Required"

        case .internalServerError: return "500 Internal Server Error"
        case .notImplemented: return "501 Not Implemented"
        case .badGateway: return "502 Bad Gateway"
        case .serviceUnavailable: return "503 Service Unavailable"
        case .gatewayTimeout: return "504 Gateway Timeout"
        case .httpVersionNotSupported: return "505 HTTP Version Not Supported"
        case .custom(let code): return "\(code) Custom"
        }
    }
}

extension HTTPStatusCode: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }

    public static func <= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue <= rhs.rawValue }

    public static func >= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue >= rhs.rawValue }

    public static func > (lhs: Self, rhs: Self) -> Bool { lhs.rawValue > rhs.rawValue }
}

extension HTTPStatusCode: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
