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

extension URLResponse {
    /// The status code of the `URLResponse`.
    ///
    /// The code defaults to `OK/200` when the status code cannot be extracted from
    /// the `URLResponse` object.
    var statusCode: HTTPStatusCode {
        guard let httpUrlResponse = self as? HTTPURLResponse else { return .ok }
        return HTTPStatusCode(rawValue: httpUrlResponse.statusCode)
    }

    /// The headers of the response.
    var headers: [HTTPHeader] {
        guard let httpUrlResponse = self as? HTTPURLResponse else { return [] }
        return httpUrlResponse.allHeaderFields.reduce(into: [HTTPHeader]()) { headers, header in
            if let name = header.key as? String, let value = header.value as? String {
                headers.append(HTTPHeader(name: name, value: value))
            }
        }
    }

    /// The text encoding of the response.
    ///
    /// Defaults to `UTF-8` when the text encoding cannot be extracted from
    /// the `URLResponse` object.
    var textEncoding: String.Encoding {
        guard let textEncodingName else { return .utf8 }
        return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
            CFStringConvertIANACharSetNameToEncoding(textEncodingName as CFString)
        ))
    }
}
