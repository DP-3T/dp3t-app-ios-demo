///

import DP3TSDK
import Foundation

struct NSUIStateModel: Equatable {
    var homescreen: Homescreen = Homescreen()
    var debug: Debug = Debug()
    var meldungenDetail: MeldungenDetail = MeldungenDetail()
    var begegnungenDetail: BegegnungenDetail = BegegnungenDetail()

    struct Homescreen: Equatable {
        enum Header: Equatable {
            case normal
            case error
            case warning
        }

        struct Begegnungen: Equatable {
            enum Tracing: Equatable {
                case active
                case inactive
            }

            var tracing: Tracing = .active
        }

        struct Meldungen: Equatable {
            enum Meldung: Equatable {
                case noMeldung
                case exposed
                case infected
            }

            var meldung: Meldung = .noMeldung
            var pushProblem: Bool = false
        }

        var header: Header = .normal
        var begegnungen: Begegnungen = Begegnungen()
        var meldungen: Meldungen = Meldungen()

        var meldungButtonDisabled: Bool = false
    }

    struct Debug: Equatable {
        var handshakeCount: Int?
        var lastSync: Date?
    }

    struct MeldungenDetail: Equatable {
        enum Meldung: Equatable {
            case noMeldung
            case exposed
            case infected
        }

        var meldung: Meldung = .noMeldung
    }

    struct BegegnungenDetail: Equatable {
        enum Tracing: Equatable {
            case active
            case deactivated
            case error
        }

        var tracingEnabled: Bool = true
        var tracing: Tracing = .active
    }
}
