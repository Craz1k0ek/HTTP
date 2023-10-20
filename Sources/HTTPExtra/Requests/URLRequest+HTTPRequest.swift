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

import Foundation
import HTTP

extension URLRequest: HTTPRequestConvertible {
    private var method: HTTPMethod {
        guard let httpMethod else {
            return .get
        }
        return HTTPMethod(rawValue: httpMethod) ?? .get
    }

    private var headers: [HTTPHeader] {
        guard let allHTTPHeaderFields else { return [] }
        return allHTTPHeaderFields.reduce(into: [HTTPHeader]()) { headers, header in
            headers.append(HTTPHeader(name: header.key, value: header.value))
        }
    }

    public var httpRequest: HTTPRequest {
        get throws {
            guard let url else { throw URLError(.badURL) }
            return HTTPRequest(
                url: url,
                method: method,
                headers: headers,
                body: httpBody,
                timeout: timeoutInterval
            )
        }
    }
}
