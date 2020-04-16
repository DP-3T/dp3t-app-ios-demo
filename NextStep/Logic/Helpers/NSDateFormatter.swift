/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

final class NSDateFormatter {
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "de_CH")
        df.setLocalizedDateFormatFromTemplate("dd.MM.yyyy, HH:mm")
        return df
    }()

    static func getDateTimeString(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
