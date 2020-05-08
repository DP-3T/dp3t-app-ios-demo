/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

enum ExponentialDistribution {
    /// Get a random double using an exponential distribution
    /// - Parameter rate: The inverse of the upper limit
    /// - Returns: A random double between 0 and the limit
    static func sample(rate: Double = 1.0) -> Double {
        assert(rate > 0, "Cannot divide by 0")
        // We use -log(1-U) since U is [0, 1)
        return -log(1 - Double.random(in: 0 ..< 1)) / rate
    }
}
