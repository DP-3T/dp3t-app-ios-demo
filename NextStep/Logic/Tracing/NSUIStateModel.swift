///

import DP3TSDK
import Foundation

struct NSUIStateModel: Equatable {
    var homescreen: Homescreen = Homescreen()
    var debug: Debug = Debug()
    var messagesDetail: MessagesDetail = MessagesDetail()
    var encountersDetail: EncountersDetail = EncountersDetail()

    struct Homescreen: Equatable {
        enum Header: Equatable {
            case normal
            case error
            case warning
        }

        struct Encounters: Equatable {
            enum Tracing: Equatable {
                case active
                case inactive
            }

            var tracing: Tracing = .active
        }

        struct Messages: Equatable {
            enum Message: Equatable {
                case noMessage
                case exposed
                case infected
            }

            var message: Message = .noMessage
            var pushProblem: Bool = false
        }

        var header: Header = .normal
        var encounters: Encounters = Encounters()
        var messages: Messages = Messages()

        var meldungButtonDisabled: Bool = false
    }

    struct Debug: Equatable {
        var handshakeCount: Int?
        var lastSync: Date?
        var infectionStatus: InfectionStatus = .healthy
        var overwrittenInfectionState: InfectionStatus?
    }

    struct MessagesDetail: Equatable {
        enum Message: Equatable {
            case noMessage
            case exposed
            case infected
        }

        var message: Message = .noMessage
    }

    struct EncountersDetail: Equatable {
        enum Tracing: Equatable {
            case active
            case deactivated
            case error
        }

        var tracingEnabled: Bool = true
        var tracing: Tracing = .active
    }
}
