/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import CoreBluetooth
import DP3TSDK
import Foundation
import UIKit

/// Glue code between SDK and UI
class NSTracingManager: NSObject {
    /// Identifier known to
    /// https://github.com/DP-3T/dp3t-discovery/blob/master/discovery.json
    let appId = "org.dpppt.demo" // "ch.ubique.nextstep"

    static let shared = NSTracingManager()

    let uiStateManager = NSUIStateManager()

    @UBUserDefault(key: "com.ubique.nextstep.isActivated", defaultValue: true)
    public var isActivated: Bool {
        didSet {
            if isActivated {
                beginUpdatesAndTracing()
            } else {
                endTracing()
            }
            NSUIStateManager.shared.changedTracingActivated()
        }
    }

    private var central: CBCentralManager?

    func initialize() {
        do {
            try DP3TTracing.initialize(with: appId, enviroment: NSBackendEnvironment.current.sdkEnvironment)
        } catch {
            NSUIStateManager.shared.tracingStartError = error
        }

        UIApplication.shared.setMinimumBackgroundFetchInterval(databaseSyncInterval)
    }

    func beginUpdatesAndTracing() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatus), name: UIApplication.willEnterForegroundNotification, object: nil)

        if User.shared.hasCompletedOnboarding, isActivated {
            do {
                try DP3TTracing.startTracing()
                NSUIStateManager.shared.tracingStartError = nil
            } catch {
                NSUIStateManager.shared.tracingStartError = error
            }

            UBPushManager.shared.requestPushPermissions { _ in
                // ensure that push works even if onboarding has not worked
            }

            central = CBCentralManager(delegate: self, queue: nil)
        }

        updateStatus()
    }

    func endTracing() {
        DP3TTracing.stopTracing()
    }

    func resetSDK() {
        try? DP3TTracing.reset()
        NSUIStateManager.shared.overwrittenInfectionState = nil
    }

    func userHasCompletedOnboarding() {
        do {
            try DP3TTracing.startTracing()
            NSUIStateManager.shared.tracingStartError = nil
        } catch {
            NSUIStateManager.shared.tracingStartError = error
        }

        updateStatus()
    }

    enum InformationType {
        case tested
        case symptoms
    }

    func sendInformation(type _: InformationType, authString: String = "", completion: @escaping (Error?) -> Void) {
        // TODO: The onset timestamp should not be a hardcoded value, so this implementation
        // will likely change in the future, but at the moment it is unclear where the value will come from
        let exposureOffset: TimeInterval = 60 * 60 * 24 * 14 // 14 days

        DP3TTracing.iWasExposed(onset: Date().addingTimeInterval(-exposureOffset), authString: authString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(nil)
                    self.updateStatus()
                case let .failure(e):
                    completion(e)
                }
            }
        }
    }

    @objc
    private func updateStatus() {
        DP3TTracing.status { result in
            switch result {
            case let .failure(e):
                NSUIStateManager.shared.updateError = e
            case let .success(st):
                NSUIStateManager.shared.updateError = nil
                NSUIStateManager.shared.tracingState = st

                // schedule local push if exposed
                NSTracingLocalPush.shared.update(state: st)
            }
            DP3TTracing.delegate = self
        }

        syncDatabaseIfNeeded()
    }

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

    @UBOptionalUserDefault(key: "com.ubique.nextstep.lastDatabaseSync") private var lastDatabaseSync: Date?
    private var databaseIsSyncing = false
    private var databaseSyncInterval: TimeInterval = 10

    private func syncDatabase(completionHandler: ((UIBackgroundFetchResult) -> Void)?) {
        databaseIsSyncing = true
        let taskIdentifier = UIApplication.shared.beginBackgroundTask {
            // can't stop sync
        }
        DP3TTracing.sync { result in
            switch result {
            case let .failure(e):
                NSUIStateManager.shared.syncError = e
                completionHandler?(.failed)
            case .success:
                NSUIStateManager.shared.syncError = nil
                self.lastDatabaseSync = Date()

                self.updateStatus()

                completionHandler?(.newData)
            }
            if taskIdentifier != .invalid {
                UIApplication.shared.endBackgroundTask(taskIdentifier)
            }
            self.databaseIsSyncing = false
        }
    }
}

extension NSTracingManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn, isActivated {
            beginUpdatesAndTracing()
        }
    }
}

extension NSTracingManager: DP3TTracingDelegate {
    func errorOccured(_ error: DP3TTracingErrors) {
        DispatchQueue.main.async {
            NSUIStateManager.shared.updateError = error
        }
    }

    func DP3TTracingStateChanged(_ state: TracingState) {
        DispatchQueue.main.async {
            NSUIStateManager.shared.updateError = nil
            NSUIStateManager.shared.tracingState = state
        }
    }
}
