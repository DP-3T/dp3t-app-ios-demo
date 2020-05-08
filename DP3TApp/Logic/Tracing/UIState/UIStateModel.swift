/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

/// Global state model for all screens that are connected to tracing state and results
/// We use a single state model to ensure that all elements have a consistent state
struct UIStateModel: Equatable {
    var homescreen: Homescreen = Homescreen()
    var begegnungenDetail: BegegnungenDetail = BegegnungenDetail()
    var shouldStartAtMeldungenDetail = false
    var meldungenDetail: MeldungenDetail = MeldungenDetail()

    #if ENABLE_TESTING
    var debug: Debug = Debug()
    #endif

    enum TracingState: Equatable {
        case tracingActive
        case tracingDisabled
        case bluetoothTurnedOff
        case bluetoothPermissionError
        case timeInconsistencyError
        case unexpectedError(code: String?)
        case tracingEnded
    }

    enum MeldungState: Equatable {
        case noMeldung
        case exposed
        case infected
    }

    struct Homescreen: Equatable {
        struct Meldungen: Equatable {
            var meldung: MeldungState = .noMeldung
            var lastMeldung: Date?
            var pushProblem: Bool = false
            var syncProblemNetworkingError: Bool = false
            var syncProblemOtherError: Bool = false
            var backgroundUpdateProblem: Bool = false
            var errorCode: String? = nil
        }

        struct InfoBox: Equatable {
            var title: String
            var text: String
            var link: String?
            var url: URL?
        }

        var header: TracingState = .tracingActive
        var begegnungen: TracingState = .tracingActive
        var meldungen: Meldungen = Meldungen()
        var infoBox: InfoBox?
    }

    struct BegegnungenDetail: Equatable {
        var tracingEnabled: Bool = true
        var tracing: TracingState = .tracingActive
    }

    struct MeldungenDetail: Equatable {
        var meldung: MeldungState = .noMeldung
        var meldungen: [NSMeldungModel] = []
        var phoneCallState: PhoneCallState = .notCalled
        var showMeldungWithAnimation: Bool = false

        struct NSMeldungModel: Equatable {
            let identifier: Int
            let timestamp: Date
        }

        enum PhoneCallState: Equatable {
            case notCalled
            case calledAfterLastExposure
            case multipleExposuresNotCalled
        }
    }


    #if ENABLE_TESTING
    struct Debug: Equatable {
        var handshakeCount: Int?
        var contactCount: Int?
        var lastSync: Date?
        var infectionStatus: DebugInfectionStatus = .healthy
        var overwrittenInfectionState: DebugInfectionStatus?
        var secretKeyRepresentation: String?
        var logOutput: NSAttributedString = NSAttributedString()

        enum DebugInfectionStatus: Equatable {
            case healthy
            case exposed
            case infected
        }
    }
    #endif
}
