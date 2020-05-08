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

    private static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        return dateFormatter
    }()

    static func ub_string(from date: Date) -> String {
        dateFormatter.string(from: date)
    }

    static func ub_daysAgo(from date: Date, addExplicitDate: Bool) -> String {
        let days = date.ns_differenceInDaysWithDate(date: Date())

        var daysAgo = ""

        if days == 0 {
            daysAgo = "date_today".ub_localized
        } else if days == 1 {
            daysAgo = "date_one_day_ago".ub_localized
        } else {
            daysAgo = "date_days_ago".ub_localized.replacingOccurrences(of: "{COUNT}", with: "\(days)")
        }

        if addExplicitDate {
            let dateText = "date_text_before_date".ub_localized.replacingOccurrences(of: "{DATE}", with: dayDateFormatter.string(from: date))

            return "\(dateText) / \(daysAgo)"
        } else {
            return daysAgo
        }
    }

    static func ub_inDays(until date: Date) -> String {
        let days = Date().ns_differenceInDaysWithDate(date: date)

        if days <= 1 {
            return "date_in_one_day".ub_localized
        } else {
            return "date_in_days".ub_localized.replacingOccurrences(of: "{COUNT}", with: "\(days)")
        }
    }
}

extension Date {
    func ns_differenceInDaysWithDate(date: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
