// swift-tools-version: 5.9

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

import PackageDescription

let package = Package(
    name: "HTTP",
    products: [
        .library(name: "HTTP", targets: ["HTTP", "HTTPExtra"]),
    ],
    targets: [
        .target(name: "HTTP"),
        .testTarget(name: "HTTPTests", dependencies: ["HTTP"]),

        .target(name: "HTTPExtra", dependencies: ["HTTP"]),
        .testTarget(name: "HTTPExtraTests", dependencies: ["HTTPExtra"]),
    ]
)

