/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

#if ENABLE_TESTING
    import DP3TSDK_CALIBRATION
#else
    import DP3TSDK
#endif

class DatabaseSyncer {
    static var shared: DatabaseSyncer {
        TracingManager.shared.databaseSyncer
    }

    private var databaseSyncInterval: TimeInterval = 10

    func performFetch(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        syncDatabaseIfNeeded(completionHandler: completionHandler)
    }

    func syncDatabaseIfNeeded(completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
        guard !databaseIsSyncing else {
            completionHandler?(.noData)
            return
        }

        if lastDatabaseSync == nil || -(lastDatabaseSync!.timeIntervalSinceNow) > databaseSyncInterval {
            syncDatabase(completionHandler: completionHandler)
        }
    }

    func forceSyncDatabase() {
        syncDatabase(completionHandler: nil)
    }

    @UBOptionalUserDefault(key: "lastDatabaseSync") private var lastDatabaseSync: Date?
    private var databaseIsSyncing = false

    private func syncDatabase(completionHandler: ((UIBackgroundFetchResult) -> Void)?) {
        databaseIsSyncing = true
        let taskIdentifier = UIApplication.shared.beginBackgroundTask {
            // can't stop sync
        }
        Logger.log("Start Database Sync", appState: true)
        DP3TTracing.sync { result in
            switch result {
            case let .failure(e):

                // 3 kinds of errors with different behaviour
                // - network, things that happen on mobile -> only show error if not recovered for 24h
                // - time inconsitency error -> detected during sync, but actually a tracing problem
                // - unexpected errors -> immediately show, backend could  be broken
                UIStateManager.shared.blockUpdate {
                    UIStateManager.shared.syncError = e
                    if case let DP3TTracingError.networkingError(wrappedError) = e {
                        switch wrappedError {
                        case .timeInconsistency:
                            UIStateManager.shared.hasTimeInconsistencyError = true
                        default:
                            break
                        }
                        UIStateManager.shared.lastSyncErrorTime = Date()
                        if case DP3TNetworkingError.networkSessionError = wrappedError {
                            UIStateManager.shared.immediatelyShowSyncError = false
                        } else {
                            UIStateManager.shared.immediatelyShowSyncError = true
                        }
                    } else {
                        UIStateManager.shared.immediatelyShowSyncError = true
                    }
                }

                Logger.log("Sync Database failed, \(e)")

                completionHandler?(.failed)
            case .success:

                // reset errors in UI
                UIStateManager.shared.blockUpdate {
                    self.lastDatabaseSync = Date()
                    UIStateManager.shared.firstSyncErrorTime = nil
                    UIStateManager.shared.lastSyncErrorTime = nil
                    UIStateManager.shared.hasTimeInconsistencyError = false
                    UIStateManager.shared.immediatelyShowSyncError = false
                }

                // wait another 2 days befor warning
                TracingLocalPush.shared.resetSyncWarningTriggers()

                // reload status, user could have been exposed
                TracingManager.shared.updateStatus(completion: nil)

                completionHandler?(.newData)


            }
            if taskIdentifier != .invalid {
                UIApplication.shared.endBackgroundTask(taskIdentifier)
            }
            self.databaseIsSyncing = false
        }
    }
}
