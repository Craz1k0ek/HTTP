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

import HTTP

public enum StringDecodingError: Error {
    /// Failed to decode the string from the encoded form.
    case decodingFailed
}

extension String: HTTPResponseConvertible {
    public static func convert(from response: HTTPResponse) throws -> String {
        guard let string = String(data: response.body, encoding: response.textEncoding) else {
            throw StringDecodingError.decodingFailed
        }
        return string
    }
}
