/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

class Logger {

    #if ENABLE_TESTING
    @UBUserDefault(key: "debugLogs", defaultValue: [])
    static private var debugLogs: [String]

    @UBUserDefault(key: "debugDates", defaultValue: [])
    static private var debugDates: [Date]

    static private let logQueue = DispatchQueue(label: "logger")

    static let changedNotification = Notification.Name(rawValue: "LoggerChanged")

    static var lastLogs: [(Date, String)] {
        Array(zip(debugDates, debugLogs))
    }

    #endif

    private init() {}



    public static func log(_ log: Any, appState: Bool = false) {
        #if ENABLE_TESTING

        Logger.logQueue.async {
            var text = String(describing: log)
            if appState {
                DispatchQueue.main.sync {
                    switch UIApplication.shared.applicationState {
                        case .active:
                            text += ", active"
                        case .inactive:
                            text += ", inactive"
                        case .background:
                            text += ", background"
                        @unknown default:
                            text += ", unknown"
                    }
                }
            }
            Logger.debugLogs.append(text)
            Logger.debugDates.append(Date())

            if Logger.debugLogs.count > 100 {
                Logger.debugLogs = Array(Logger.debugLogs.dropFirst())
                Logger.debugDates = Array(Logger.debugDates.dropFirst())
            }

            UIStateManager.shared.refresh()
        }

        #endif
    }

}
