//
//  URLResponseStub.swift
//  
//
//  Created by Bram Kolkman on 24/10/2022.
//

import Foundation

final class URLResponseStub: URLProtocol {
    static var urls = [URL]()

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else {
            return false
        }
        return urls.contains(url)
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url else {
            fatalError("Missing url for \(request)")
        }

        DispatchQueue.global(qos: .background).async {
            self.client?.urlProtocol(self, didLoad: Data())
            self.client?.urlProtocol(self, didReceive: URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil), cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}
