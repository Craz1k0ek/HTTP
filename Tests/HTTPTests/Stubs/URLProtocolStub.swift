//
//  URLProtocolStub.swift
//  
//
//  Created by Bram Kolkman on 24/10/2022.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    static var responses = [URL: Result<Data, Error>]()

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
        DispatchQueue.global(qos: .background).async {
            switch response {
            case let .success(data):
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: url, mimeType: nil, expectedContentLength: data.count, textEncodingName: nil), cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocolDidFinishLoading(self)
            case let .failure(error):
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() {}
}
