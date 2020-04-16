/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

class User {
    static let shared = User()

    @UBUserDefault(key: "com.ubique.nextstep.hascompletedonboarding", defaultValue: false)
    var hasCompletedOnboarding: Bool {
        didSet {
            NSTracingManager.shared.userHasCompletedOnboarding()
        }
    }
}
