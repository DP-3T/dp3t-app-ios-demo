/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

class NSPushHandler: UBPushHandler {
    override func showInAppPushAlert(withTitle _: String, proposedMessage _: String, notification _: UBPushNotification) {
        // called for every received push when the app is in foreground
        // we don't show push in app, so we can ignore it
    }

    override func updateLocalData(withSilent _: Bool, remoteNotification _: UBPushNotification) {
        // for every received push, we enforce a database sync
        NSTracingManager.shared.forceSyncDatabase()
    }
}
