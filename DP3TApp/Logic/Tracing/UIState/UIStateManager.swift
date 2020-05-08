/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import CoreBluetooth
import Foundation
import UIKit

#if ENABLE_TESTING
    import DP3TSDK_CALIBRATION
#else
    import DP3TSDK
#endif

class UIStateManager: NSObject {
    static var shared: UIStateManager {
        TracingManager.shared.uiStateManager
    }

    let syncProblemInterval: TimeInterval = 60 * 60 * 24 // 1 day

    override init() {
        // only one instance
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(updatePush), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    // MARK: - UI State Update

    private(set) var uiState: UIStateModel! {
        didSet {
            var stateHasChanged = uiState != oldValue

            // don't trigger ui update based on debug values
            // otherwise behaviour in prob build could be different
            #if ENABLE_TESTING
                var newUIStateWithoutDebug = uiState
                newUIStateWithoutDebug?.debug = .init()
                var oldUIStateWithoutDebug = oldValue
                oldUIStateWithoutDebug?.debug = .init()
                stateHasChanged = newUIStateWithoutDebug != oldUIStateWithoutDebug
            #endif
            if stateHasChanged {
                observers = observers.filter { $0.object != nil }
                DispatchQueue.main.async {
                    self.observers.forEach { observer in
                        observer.block(self.uiState)
                    }
                }
                dprint("New UI State")
            }
        }
    }

    func refresh() {
        // disable updates until end of block update
        guard !isPerformingBlockUpdate else {
            return
        }

        // we don't have callback for push permission
        // thus fetch state with every refresh
        updatePush()

        // build new state, sending update to observers if changed
        uiState = UIStateLogic(manager: self).buildState()
    }

    // MARK: - Block Update

    private var isPerformingBlockUpdate = false

    func blockUpdate(_ update: () -> Void) {
        isPerformingBlockUpdate = true
        update()
        isPerformingBlockUpdate = false
        refresh()
    }

    // MARK: - State Observers

    struct Observer {
        weak var object: AnyObject?
        var block: (UIStateModel) -> Void
    }

    private var observers: [Observer] = []

    func addObserver(_ object: AnyObject, block: @escaping (UIStateModel) -> Void) {
        observers.append(Observer(object: object, block: block))
        block(uiState)
    }

    // MARK: - Variables that affect user state

    @UBOptionalUserDefault(key: "firstSyncErrorTime")
    var firstSyncErrorTime: Date?

    var lastSyncErrorTime: Date? {
        didSet {
            if let time = lastSyncErrorTime, firstSyncErrorTime == nil {
                firstSyncErrorTime = time
            }
            refresh()
        }
    }

    var syncError: Error? {
        didSet {
            if (syncError == nil) != (oldValue == nil) {
                refresh()
            }
        }
    }

    var immediatelyShowSyncError: Bool = false {
        didSet {
            if oldValue != immediatelyShowSyncError { refresh() }
        }
    }

    var tracingStartError: Error? {
        didSet {
            if (tracingStartError == nil) != (oldValue == nil) {
                refresh()
            }
        }
    }

    var updateError: Error? {
        didSet {
            if (updateError == nil) != (oldValue == nil) {
                refresh()
            }
        }
    }

    @UBUserDefault(key: "hasTimeInconsistencyError", defaultValue: false)
    var hasTimeInconsistencyError: Bool

    var anyError: Error? {
        tracingStartError ?? updateError
    }

    var pushOk: Bool = true

    var tracingState: TracingState?

    var trackingState: TrackingState = .stopped {
        didSet {
            switch (oldValue, trackingState) {
            // Only trigger a refresh if the tracking state has changed
            case (.active, .active), (.stopped, .stopped):
                return
            case let (.inactive(e1), .inactive(e2)):
                switch (e1, e2) {
                case (.networkingError(_), .networkingError(_)),
                     (.caseSynchronizationError, .caseSynchronizationError),
                     (.cryptographyError(_), .cryptographyError(_)),
                     (.databaseError(_), .databaseError(_)),
                     (.bluetoothTurnedOff, .bluetoothTurnedOff),
                     (.permissonError, .permissonError):
                    return
                // TODO: Long changing list of errors and default value is dangerous
                default:
                    refresh()
                }
            default:
                refresh()
            }
        }
    }

    #if ENABLE_TESTING
    var overwrittenInfectionState: UIStateModel.Debug.DebugInfectionStatus? {
        didSet { refresh() }
    }
    #endif

    var tracingIsActivated: Bool {
        TracingManager.shared.isActivated
    }

    func changedTracingActivated() {
        refresh()
    }

    func userCalledInfoLine() {
        refresh()
    }

    // MARK: - Permission Checks

    @objc private func updatePush() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let isEnabled = settings.alertSetting == .enabled
            DispatchQueue.main.async {
                if self.pushOk != isEnabled {
                    self.pushOk = isEnabled
                    self.refresh()
                }
            }
        }
    }
}
