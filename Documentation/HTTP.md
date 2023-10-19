# HTTP

The HTTP target provides core functionality to build your own network stack.
This file provides some tools to help you get started.

## Request & response

Very important components of the package are the request and response objects.

```swift
let session: HTTPSession = ...

let url = URL(string: "https://www.thinkerium.com/")!
let request = HTTPRequest(url: url)
let response = try await session.response(for: request)
```

Creating a request is as easy as simply providing an URL and using any `HTTPSession` to send it.
The request conforms to `Identifiable`, so one can keep track of specific requests 
being sent to the server.

The response object contains everything you get from the server, including the body,
and it also contains the original request through the `.originalRequest` property.
This keeps the request/response nicely linked.

## Request & response protocols

Both the request and the response can be created by conforming to the
`HTTPRequestConvertible` and `HTTPResponseConvertible` protocols respectively.
For example, one can make a `URL` easily be transformed into a request:

```swift
extension URL: HTTPRequestConvertible {
    public var httpRequest: HTTPRequest {
        HTTPRequest(url: self)
    }
}

let session: HTTPSession = ...

// Use the conformance to directly get a response object.
let url = URL(string: "https://www.thinkerium.com/")!
let response = try await session.response(for: url)
```

And when we are dealing with raw data which we expect from a server, we can easily
convert `Data` to be a response:

```swift
extension Data: HTTPResponseConvertible {
    public static func convert(from response: HTTPResponse) -> Data {
        response.body
    }
}

let session: HTTPSession = ...
// From the previous example
let url = URL(string: "https://www.thinkerium.com/")!
// Provide the response convertible type to receive
let data = try await session.response(Data.self, for: url)
```

## HTTP Session

To provide similar syntax to Apple's `URLSession`, we've opted to name an implementation
of an HTTP client an `HTTPSession`. There are two flavours of sessions, those with and
those without middleware.

### Without middleware

And example implementation using Apple's `URLSession` could look like this:

```swift
extension URLSession: HTTPSession {
    public func response(for request: HTTPRequest) async throws -> HTTPResponse {
        let (body, response) = try await data(for: request.urlRequest)

        return HTTPResponse(
            originalRequest: request,
            statusCode: response.statusCode,
            headers: response.headers,
            body: body,
            textEncoding: response.textEncoding
        )
    }
}
```

### With middleware

To show the middleware, we will have to wrap the `URLSession` a bit further.
We also use the middleware before we send the request and after we receive
the response.

```swift
struct URLClient: HTTPMiddlewareSession {
    var middleware: [Middleware] = []
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func response(for request: HTTPRequest) async throws -> HTTPResponse {
        var request = request

        for middleware in self.middleware {
            try await middleware.process(request: &request)
        }

        let response = try await session.response(for: request)

        for middleware in self.middleware {
            try await middleware.process(response: response)
        }

        return response
    }
}
```

## Middleware

The middleware can be very powerful. We could create middleware that automatically
inserts user agents, authorization tokens, or one that automatically throws an
error when an invalid status code is received. To show you how one could implement
the middleware, we're going to show you the `Accept`/`Content-Type` request/response
header check.

```swift
enum HTTPError: Error {
    case invalidContentType
}

struct ContentValidationMiddleware: Middleware {
    func process(request: inout HTTPRequest) async throws {
        if !request.headers.contains(where: { $0.name == "Accept" }) {
            request.headers.append(.contentType(.applicationJSON))
        }
    }

    func process(response: HTTPResponse) async throws {
        guard let accept = response.originalRequest.headers["Accept"] else { return }

        guard let contentType = response.headers["Content-Type"], contentType.value == accept.value else {
            throw HTTPError.invalidContentType
        }
    }
}
```

This middleware automatically adds the `application/json` _Accept_ header when it's missing.
Upon response the response will check the request's _Accept_ header and compare it to the 
_Content-Type_ header of the response. If the values do not match, the middleware will
throw an error.

