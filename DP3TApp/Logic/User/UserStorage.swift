/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class UserStorage {
    static let shared = UserStorage()

    @UBUserDefault(key: "hasCompletedOnboarding", defaultValue: false)
    var hasCompletedOnboarding: Bool {
        didSet {
            TracingManager.shared.userHasCompletedOnboarding()
        }
    }

    func registerPhoneCall(identifier: Int) {
        var lastPhoneCalls = self.lastPhoneCalls
        // we only want the last
        lastPhoneCalls.removeAll()
        lastPhoneCalls["\(identifier)"] = Date()

        self.lastPhoneCalls = lastPhoneCalls

        UIStateManager.shared.userCalledInfoLine()
    }

    func registerSeenMessages(identifier: Int) {
        seenMessages.append("\(identifier)")
    }

    var lastPhoneCallDate: Date? {
        let allDates = lastPhoneCalls.values

        return allDates.sorted().last
    }

    func lastPhoneCall(for identifier: Int) -> Date? {
        if lastPhoneCalls.keys.contains("\(identifier)") {
            return lastPhoneCalls["\(identifier)"]
        }

        return nil
    }

    func hasSeenMessage(for identifier: Int) -> Bool {
        return seenMessages.contains("\(identifier)")
    }

    @UBUserDefault(key: "lastPhoneCalls", defaultValue: [:])
    private var lastPhoneCalls: [String: Date]

    @UBUserDefault(key: "seenMessages", defaultValue: [])
    private var seenMessages: [String]

    @UBOptionalUserDefault(key: "positiveTestSendDate")
    public var positiveTestSendDate: Date?

}
