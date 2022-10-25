//
//  URLProtocolStub.swift
//  
//
//  Created by Bram Kolkman on 24/10/2022.
//

import Foundation
import HTTP

final class URLProtocolStub: URLProtocol {
    typealias Content = (body: Data, statusCode: HTTPStatusCode)
    static var responses = [URL: Result<Content, Error>]()

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else {
            return false
        }
        return responses.keys.contains(url)
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url, let response = Self.responses[url] else {
            fatalError("Missing response for \(request)")
        }
        // Spoof background queue
        DispatchQueue.global(qos: .background).async { [request] in
            switch response {
            case let .success(stub):
                guard let response = HTTPURLResponse(url: url, statusCode: stub.statusCode.rawValue, httpVersion: nil, headerFields: nil) else {
                    fatalError("Invalid response for \(request)")
                }
                self.client?.urlProtocol(self, didLoad: stub.body)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocolDidFinishLoading(self)
            case let .failure(error):
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() {}
}
