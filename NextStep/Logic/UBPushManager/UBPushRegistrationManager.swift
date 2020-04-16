/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

/// Handles registration of push tokens on our server
/// Clients can either create a pushRegistrationManager with a `registrationUrl`"
///
///     let registrationManager = UBPushRegistrationManager(registrationUrl: registrationUrl)
///
/// or subclass `UBPushRegistrationManager`, overriding `pushRegistrationRequest` if they
/// require a custom registration request.
open class UBPushRegistrationManager {
    /// The push token for this device, if any
    public var pushToken: String? {
        UBPushLocalStorage.shared.pushToken
    }

    /// The url needed for the registration request
    private var registrationUrl: URL?

    /// :nodoc:
    private var maxRegistrationAge: TimeInterval {
        2 * 7 * 24 * 60 * 60 // enforce new push registration every two weeks
    }

    /// :nodoc:
    private let session = URLSession.shared
    private var task: URLSessionDataTask?

    // MARK: - Initialization

    /// Creates push registration manager for the provided `registrationUrl`
    public init(registrationUrl: URL? = nil) {
        self.registrationUrl = registrationUrl
    }

    /// Sets the push token for the device, which starts a push registration
    func setPushToken(_ pushToken: String?) {
        let oldToken = UBPushLocalStorage.shared.pushToken

        // we could receive the same push token again
        // only send registration if push token has changed
        if oldToken != nil || oldToken != pushToken {
            UBPushLocalStorage.shared.pushToken = pushToken
            invalidate()
        }
    }

    /// :nodoc:
    private func validate() {
        UBPushLocalStorage.shared.isValid = true
        UBPushLocalStorage.shared.lastRegistrationDate = Date()
    }

    /// :nodoc:
    func invalidate() {
        UBPushLocalStorage.shared.isValid = false
        sendPushRegistration()
    }

    /// :nodoc:
    private func sendPushRegistration(completion: ((Error) -> Void)? = nil) {
        guard let registrationRequest = pushRegistrationRequest else {
            completion?(UBPushManagerError.registrationRequestMissing)
            return
        }

        var backgroundTask = UIBackgroundTaskIdentifier.invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(backgroundTask)
        }

        task = session.dataTask(with: registrationRequest, completionHandler: { [weak self] data, _, error in
            guard let strongSelf = self else { return }

            if let e = error {
                completion?(e)
            } else if let d = data, let _ = String(data: d, encoding: .utf8) {
                strongSelf.validate()
            }

            if backgroundTask != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTask)
            }
        })

        task?.resume()
    }

    /// The registration request sent to the server. Clients may override this property to
    /// implement a custom registration request
    open var pushRegistrationRequest: URLRequest? {
        guard
            let pushToken = UBPushLocalStorage.shared.pushToken,
            let registrationUrl = self.registrationUrl else {
            return nil
        }

        var request = URLRequest(url: registrationUrl, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        guard let body = try? JSONSerialization.data(withJSONObject: [
            "deviceUUID": pushDeviceUUID,
            "pushToken": pushToken,
            "type": "IOS",
        ], options: []) else {
            return nil
        }
        request.httpBody = body

        return request
    }

    /// :nodoc:
    func sendPushRegistrationIfOutdated() {
        if !UBPushLocalStorage.shared.isValid {
            sendPushRegistration()
        } else {
            let justPushed = UBPushManager.shared.pushHandler.lastPushed.map { lastPushed in
                let fifteenSecondsAgo = Date(timeIntervalSinceNow: -15 * 60)
                return lastPushed > fifteenSecondsAgo
            } ?? false

            let outdated = -(UBPushLocalStorage.shared.lastRegistrationDate?.timeIntervalSinceNow ?? 0) > maxRegistrationAge

            if outdated, !justPushed {
                invalidate()
            }
        }
    }

    // MARK: - UUID

    /// :nodoc:
    open var pushDeviceUUID: String {
        UBDeviceUUID.getUUID()
    }
}

// MARK: - Push Registration Request

private extension UBPushRegistrationManager {
    /// Data POSTed to the registrationUrl in the default implementation
    struct Request: Codable {
        let deviceUUID: String
        let pushToken: String
        let type = "IOS"
    }
}
