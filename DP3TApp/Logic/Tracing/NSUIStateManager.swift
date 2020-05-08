///

import CoreBluetooth
import Foundation
import UIKit

#if CALIBRATION_SDK
    import DP3TSDK_CALIBRATION
#else
    import DP3TSDK
#endif

class UIStateManager: NSObject {
    static var shared: UIStateManager {
        TracingManager.shared.uiStateManager
    }

    let syncProblemInterval: TimeInterval = 60 * 60 * 24 // 1 day

    @UBOptionalUserDefault(key: "com.ubique.nextstep.firstSyncErrorTime")
    var firstSyncErrorTime: Date?

    var lastSyncErrorTime: Date? {
        didSet {
            if let time = lastSyncErrorTime, firstSyncErrorTime == nil {
                firstSyncErrorTime = time
            }
            refresh()
        }
    }

    var syncError: Error? { didSet { refresh() } }

    var tracingStartError: Error? { didSet { refresh() } }
    var updateError: Error? { didSet { refresh() } }

    @UBUserDefault(key: "com.ubique.nextstep.hasTimeInconsistencyError", defaultValue: false)
    var hasTimeInconsistencyError: Bool

    var anyError: Error? {
        tracingStartError ?? updateError
    }

    var pushOk: Bool = false {
        didSet {
            if pushOk != oldValue { refresh() }
        }
    }

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
                     (.permissonError, .permissonError),
                     (.jwtSignitureError, .jwtSignitureError),
                     (.timeInconsistency(_), .timeInconsistency(_)):
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

    var overwrittenInfectionState: DebugInfectionStatus? {
        didSet { refresh() }
    }

    var tracingIsActivated: Bool {
        TracingManager.shared.isActivated
    }

    func changedTracingActivated() {
        refresh()
    }

    func userCalledInfoLine() {
        refresh()
    }

    override init() {
        // only one instance
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(updatePush), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    // MARK: - State Observers

    struct Observer {
        weak var object: AnyObject?
        var block: (NSUIStateModel) -> Void
    }

    private var observers: [Observer] = []

    func addObserver(_ object: AnyObject, block: @escaping (NSUIStateModel) -> Void) {
        observers.append(Observer(object: object, block: block))
        block(uiState)
    }

    var uiState: NSUIStateModel! {
        didSet {
            if uiState != oldValue {
                observers = observers.filter { $0.object != nil }
                observers.forEach { $0.block(uiState) }
            }
        }
    }

    func refresh() {
        updatePush()

        uiState = UIStateLogic.state(from: self)
    }

    // MARK: - Permission Checks

    @objc private func updatePush() {
        UBPushManager.shared.queryPushPermissions { success in
            self.pushOk = success
        }
    }
}
