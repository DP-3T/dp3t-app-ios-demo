/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

/// To support fast iterations and show different scenarios, Next Step can be build with different UI versions
struct NSContentEnvironment {
    static let current = NSContentEnvironment()

    /// Showcase of a generic tracer, independent of COVID-19
    var isGenericTracer: Bool {
        return false
    }

    /// Showcase of a tracer of COVID-19 infections
    var isCOVIDTracer: Bool {
        return true
    }

    /// If the app should ask for symptoms, otherwise an positive test for COVID-19 is assumed or required
    var hasSymptomInputs: Bool {
        return false
    }

    /// If additional tabs with information content should be visible
    var hasTabBar: Bool {
        return false
    }
}
