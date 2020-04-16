/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import DP3TSDK
import Foundation
import UserNotifications

/// Helper to show a local push notification when the state of the user changes from not-exposed to exposed
class NSTracingLocalPush {
    static let shared = NSTracingLocalPush()

    func update(state: TracingState) {
        switch state.infectionStatus {
        case .exposed:
            userHasBeenExposed = true
        case .healthy:
            userHasBeenExposed = false
        case .infected:
            break // don't update
        }
    }

    @UBUserDefault(key: "com.ubique.nextstep.hasBeenExposed", defaultValue: false)
    private var userHasBeenExposed: Bool {
        didSet {
            if userHasBeenExposed, !oldValue {
                let content = UNMutableNotificationContent()
                content.title = "push_exposed_title".ub_localized
                content.body = "push_exposed_text".ub_localized

                let request = UNNotificationRequest(identifier: "ch.ubique.push.exposed", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
}
