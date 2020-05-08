# DP3T iOS Demo App

[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-%E2%9C%93-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://github.com/DP-3T/dp3t-sdk-ios/blob/master/LICENSE)
![build](https://github.com/DP-3T/dp3t-app-ios/workflows/build/badge.svg)

## DP3T
The Decentralised Privacy-Preserving Proximity Tracing (DP-3T) project is an open protocol for COVID-19 proximity tracing using Bluetooth Low Energy functionality on mobile devices that ensures personal data and computation stays entirely on an individual's phone. It was produced by a core team of over 25 scientists and academic researchers from across Europe. It has also been scrutinized and improved by the wider community.

DP-3T is a free-standing effort started at EPFL and ETHZ that produced this protocol and that is implementing it in an open-sourced app and server.


## Introduction
This is a COVID-19 tracing demo client using the [DP3T iOS SDK](https://github.com/DP-3T/dp3t-sdk-ios). It shows how the SDK can be used in a real, but simplified app. For a more complete solution, check the [DP3T iOS App Switzerland](https://github.com/DP-3T/dp3t-app-ios-ch), which also contains certificate pinning and other additional security features.


## Contribution Guide

The DP3T App is not yet complete. It has not yet been reviewed or audited for security and compatibility. We are both continuing the development and have started a security review. This project is truly open-source and we welcome any feedback on the code regarding both the implementation and security aspects.

Bugs or potential problems should be reported using Github issues. We welcome all pull requests that improve the quality the source code or the demo app itself.

## Repositories
* Android SDK & Calibration app: [dp3t-sdk-android](https://github.com/DP-3T/dp3t-sdk-android)
* iOS SDK & Calibration app: [dp3t-sdk-ios](https://github.com/DP-3T/dp3t-sdk-ios)
* Android Demo App: [dp3t-app-android](https://github.com/DP-3T/dp3t-app-android)
* Android App Switzerland: [dp3t-app-android-ch](https://github.com/DP-3T/dp3t-app-android-ch)
* iOS Demo App: [dp3t-app-ios](https://github.com/DP-3T/dp3t-app-ios)
* iOS App Switzerland: [dp3t-app-ios-ch](https://github.com/DP-3T/dp3t-app-ios-ch)
* Backend SDK: [dp3t-sdk-backend](https://github.com/DP-3T/dp3t-sdk-backend)


## Further Documentation
The full set of documents for DP3T is at https://github.com/DP-3T/documents. Please refer to the technical documents and whitepapers for a description of the implementation.


## Installation and Building

The project should be opened with the latest Xcode versions, 11.4. Dependencies are managed with [Swift Package Manager](https://swift.org/package-manager), no further setup is needed. If you're not in the Ubique Innovation AG team, you should choose your own team in Signing & Capabilities.



## License
This project is licensed under the terms of the MPL 2 license. See the [LICENSE](LICENSE) file.
