/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

/// Convenience for converting dates into user-displayable strings in a unified form.
extension DateFormatter {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    static func ub_string(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
