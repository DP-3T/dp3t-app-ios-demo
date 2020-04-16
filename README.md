# DP3T iOS Demo App

[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-%E2%9C%93-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://github.com/DP-3T/dp3t-sdk-ios/blob/master/LICENSE)


## DP3T
The Decentralised Privacy-Preserving Proximity Tracing (DP-3T) project is an open protocol for COVID-19 proximity tracing using Bluetooth Low Energy functionality on mobile devices that ensures personal data and computation stays entirely on an individual's phone. It was produced by a core team of over 25 scientists and academic researchers from across Europe. It has also been scrutinized and improved by the wider community.

DP-3T is a free-standing effort started at EPFL and ETHZ that produced this protocol and that is implementing it in an open-sourced app and server.


## Introduction
This is the first implementation of a client using the [DP3T iOS SDK](https://github.com/DP-3T/dp3t-sdk-ios). You can join the [beta test group](https://testflight.apple.com/join/DkKO0Mhd) on TestFlight to get pre-built updates.

<p align="center">
<img src="Documentation/screenshots/screenshot_homescreen.png" width="256">
<img src="Documentation/screenshots/screenshot_encounters.png" width="256">
<img src="Documentation/screenshots/screenshot_thankyou.png" width="256">
</p>

## Repositories
* Android SDK & Calibration app: [dp3t-sdk-android](https://github.com/DP-3T/dp3t-sdk-android)
* iOS SDK & Calibration app: [dp3t-sdk-ios](https://github.com/DP-3T/dp3t-sdk-ios)
* Android Demo App: [dp3t-app-android](https://github.com/DP-3T/dp3t-app-android)
* iOS Demo App: [dp3t-app-ios](https://github.com/DP-3T/dp3t-app-ios)
* Backend SDK: [dp3t-sdk-backend](https://github.com/DP-3T/dp3t-sdk-backend)

## Work in Progress
The demo app shows how the SDK can be used in a real app, but all content and UX aspects, especially messages and navigation flows are in an alpha stage. The current version requests a 6-digit code to verify a positive test, but every code will be accepted.

## Further Documentation
The full set of documents for DP3T is at https://github.com/DP-3T/documents. Please refer to the technical documents and whitepapers for a description of the implementation.


## Installation and Building

The project should be opened with the latest Xcode versions, 11.4. Dependencies are managed with [Swift Package Manager](https://swift.org/package-manager), no further setup is needed. If you're not in the Ubique Innovation AG team, you should choose your own team in Signing & Capabilities.

## License
This project is licensed under the terms of the MPL 2 license. See the [LICENSE](LICENSE) file.
