/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

#if ENABLE_TESTING
    import DP3TSDK_CALIBRATION
#else
    import DP3TSDK
#endif

import Foundation

class ReportingManager {
    // MARK: - Shared

    static let shared = ReportingManager()

    // MARK: - Init

    private init() {}

    // MARK: - Variables

    enum ReportingProblem {
        case failure(error: Error)
        case invalidCode
    }


    // MARK: - API


    func report(covidCode: String, completion: @escaping (ReportingProblem?) -> Void) {
       sendIWasExposed(token: covidCode, date: Date(), isFakeRequest: false, completion: completion)
    }

    // MARK: - Second part: I was exposed

    private func sendIWasExposed(token: String, date: Date, isFakeRequest fake: Bool, completion: @escaping (ReportingProblem?) -> Void) {
        DP3TTracing.iWasExposed(onset: date, authentication: .none, isFakeRequest: fake) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    TracingManager.shared.updateStatus { error in
                        if let error = error {
                            completion(.failure(error: error))
                        } else {
                            UserStorage.shared.positiveTestSendDate = Date()
                            completion(nil)
                        }
                    }
                case let .failure(error):
                    completion(.failure(error: error))
                }
            }
        }
    }
}
