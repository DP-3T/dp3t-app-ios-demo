/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

/// A value which can be stored in `UserDefaults` using
/// the `UBUserDefault` and `UBOptionalUserDefault` property wrappers
///
/// Plist-Compatible values are supported out of the box. Please refer to `UBPListValue` to see the supported types.
/// To store `Codable` types in `UserDefaults`, please conform to `UBCodable`.
/// To store `RawRepresentable` types in `UserDefaults`, please conform to `UBRawRepresentable`.
public typealias UBUserDefaultValue = UBUserDefaultsStorable & UBUserDefaultsRetrievable

public protocol UBUserDefaultsStorable {
    func store(in userDefaults: UserDefaults, key: String)
}

public protocol UBUserDefaultsRetrievable {
    static func retrieve(from userDefaults: UserDefaults, key: String, defaultValue: Self) -> Self

    static func retrieveOptional(from userDefaults: UserDefaults, key: String) -> Self?
}
