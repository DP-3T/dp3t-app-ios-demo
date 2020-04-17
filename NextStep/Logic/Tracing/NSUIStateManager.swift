///

import CoreBluetooth
import DP3TSDK
import Foundation
import UIKit

class NSUIStateManager: NSObject {
    static var shared: NSUIStateManager {
        return NSTracingManager.shared.uiStateManager
    }

    var tracingStartError: Error? { didSet { refresh() } }
    var updateError: Error? { didSet { refresh() } }
    var syncError: Error? { didSet { refresh() } }

    var anyError: Error? {
        tracingStartError ?? updateError ?? syncError
    }

    private var bluetoothOk: Bool = true {
        didSet { refresh() }
    }

    private var pushOk: Bool = false {
        didSet {
            if pushOk != oldValue { refresh() }
        }
    }

    var tracingState: TracingState?

    var overwrittenInfectionState: InfectionStatus? {
        didSet { refresh() }
    }

    var tracingIsActivated: Bool {
        NSTracingManager.shared.isActivated
    }

    func changedTracingActivated() {
        refresh()
    }

    override init() {
        // only one instance

        super.init()

        if User.shared.hasCompletedOnboarding {
            initializeBluetoothObserver()
        }

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
        if User.shared.hasCompletedOnboarding, central == nil {
            initializeBluetoothObserver()
        }

        updatePush()

        uiState = reloadedUIState()
    }

    func reloadedUIState() -> NSUIStateModel {
        var newState = NSUIStateModel()

        var tracingNotWorking = false

        switch tracingState?.trackingState {
        case .active:
            // skd says tracking works.

            // other checks, maybe not needed
            if anyError != nil || !bluetoothOk || !tracingIsActivated {
                tracingNotWorking = true
            }

        default:
            tracingNotWorking = true
        }

        if tracingNotWorking {
            newState.homescreen.header = .error
            newState.homescreen.begegnungen.tracing = .inactive
        }

        if !tracingIsActivated {
            newState.begegnungenDetail.tracingEnabled = false
            newState.begegnungenDetail.tracing = .deactivated
        } else if tracingNotWorking {
            newState.begegnungenDetail.tracing = .error
        }

        if !pushOk {
            newState.homescreen.meldungen.pushProblem = true
        }

        if let tracingState = tracingState {
            var infectionStatus = tracingState.infectionStatus
            if let os = overwrittenInfectionState {
                infectionStatus = os
            }

            switch infectionStatus {
            case .healthy:
                break
            case .infected:
                newState.homescreen.meldungButtonDisabled = true
                newState.homescreen.meldungen.meldung = .infected
                newState.meldungenDetail.meldung = .infected
            case .exposed:
                newState.homescreen.meldungen.meldung = .exposed
                newState.meldungenDetail.meldung = .exposed
            }

            newState.debug.handshakeCount = tracingState.numberOfHandshakes
            newState.debug.lastSync = tracingState.lastSync
            // add real tracing state of sdk and overwritten state
            newState.debug.infectionStatus = tracingState.infectionStatus
            newState.debug.overwrittenInfectionState = overwrittenInfectionState
        }

        return newState
    }

    // MARK: - Permission Checks

    @objc private func updatePush() {
        UBPushManager.shared.queryPushPermissions { success in
            self.pushOk = success
        }
    }

    private var central: CBCentralManager?

    private func initializeBluetoothObserver() {
        central = CBCentralManager(delegate: self, queue: nil)
    }
}

extension NSUIStateManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothOk = central.state == .poweredOn
    }
}
