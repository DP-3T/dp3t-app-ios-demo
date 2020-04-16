/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

/// Errors thrown by the push manager
public enum UBPushManagerError: Error {
    /// The request for push registration could not be formed
    case registrationRequestMissing
}
