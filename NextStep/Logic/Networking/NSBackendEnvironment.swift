/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import DP3TSDK
import Foundation

/// The backend environment under which the application runs.
enum NSBackendEnvironment {
    case debug
    case dev
    case prod

    /// The base URL of the API.
    var staticApiBaseURL: URL {
        let baseURLString: String
        switch self {
        case .debug: fallthrough
        case .dev:
            baseURLString = "https://next-step.io/"
        case .prod:
            baseURLString = "https://next-step.io/"
        }

        return URL(string: baseURLString)!.appendingPathComponent("language_key".ub_localized)
    }

    var wsApiBaseURL: URL {
        let baseURLString: String
        switch self {
        case .debug: fallthrough
        case .dev:
            baseURLString = "https://ws-app-dev.next-step.io"
        case .prod:
            baseURLString = "https://ws-app-prod.next-step.io"
        }

        return URL(string: baseURLString)!
    }

    /// The current environment, as configured in build settings.
    static var current: NSBackendEnvironment {
        #if DEBUG
            return .debug
        #elseif RELEASE_TEST
            return .dev
        #elseif RELEASE_PROD
            return .prod
        #elseif RELEASE_UBDIAG
            return .dev
        #else
            fatalError("Missing build setting for environment")
        #endif
    }

    var sdkEnvironment: Enviroment {
        switch self {
        case .debug: fallthrough
        case .dev:
            return .dev
        case .prod:
            return .prod
        }
    }
}

struct NSEndpoint {
    let version: String? = "v1"
    let method: String = "GET"
    let url: URL
    let queryParameters: [URLQueryItem]?
    let headers: [String: String]?

    // MARK: - Init

    private init(baseUrl: URL = NSBackendEnvironment.current.wsApiBaseURL,
                 version: String? = "v1",
                 path: String,
                 queryParameters: [URLQueryItem]? = nil,
                 headers: [String: String]? = nil) {
        var components = URLComponents(url: baseUrl.appendingPathComponent(version ?? "").appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryParameters
        url = components.url!
        self.queryParameters = queryParameters
        self.headers = headers
    }

    // MARK: - Request

    func request(timeoutInterval: TimeInterval = 30.0) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = method

        for (k, v) in headers ?? [:] {
            request.setValue(v, forHTTPHeaderField: k)
        }

        return request
    }

    // MARK: - Static

    static let config = NSEndpoint(path: "config", headers: ["User-Agent": "ios",
                                                             "App-Device-Token": UBDeviceUUID.getUUID()])

    static let register = NSEndpoint(path: "register", headers: ["User-Agent": "ios",
                                                                 "App-Device-Token": UBDeviceUUID.getUUID()])
}
