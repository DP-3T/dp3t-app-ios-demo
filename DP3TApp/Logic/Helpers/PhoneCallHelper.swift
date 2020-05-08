/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class PhoneCallHelper: NSObject {
    // MARK: - API

    public static func call(_ phoneNumber: String) {
        let callableNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: "00")

        if let url = URL(string: "tel://\(callableNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
