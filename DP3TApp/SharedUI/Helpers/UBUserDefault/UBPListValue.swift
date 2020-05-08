/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

/// The types that can be stored in `UserDefaults` out of the box.
///
/// From the `UserDefaults Documentation`
/// "UserStorageDefaults stores Property List objects (NSString, NSData, NSNumber, NSDate, NSArray, and NSDictionary) identified by NSString keys"
public protocol UBPListValue: UBUserDefaultValue {}

extension UBPListValue {
    public func store(in userDefaults: UserDefaults, key: String) {
        userDefaults.set(self, forKey: key)
    }

    public static func retrieve(from userDefaults: UserDefaults, key: String, defaultValue: Self) -> Self {
        userDefaults.object(forKey: key) as? Self ?? defaultValue
    }

    public static func retrieveOptional(from userDefaults: UserDefaults, key: String) -> Self? {
        userDefaults.object(forKey: key) as? Self
    }
}

extension Data: UBPListValue {}
extension NSData: UBPListValue {}

extension String: UBPListValue {}
extension NSString: UBPListValue {}

extension Date: UBPListValue {}
extension NSDate: UBPListValue {}

extension NSNumber: UBPListValue {}
extension Bool: UBPListValue {}
extension Int: UBPListValue {}
extension Int8: UBPListValue {}
extension Int16: UBPListValue {}
extension Int32: UBPListValue {}
extension Int64: UBPListValue {}
extension UInt: UBPListValue {}
extension UInt8: UBPListValue {}
extension UInt16: UBPListValue {}
extension UInt32: UBPListValue {}
extension UInt64: UBPListValue {}
extension Double: UBPListValue {}
extension Float: UBPListValue {}

extension Array: UBPListValue where Element: UBPListValue {}

extension Array: UBUserDefaultValue where Element: UBUserDefaultValue {
    public static func retrieve(from userDefaults: UserDefaults, key: String, defaultValue: [Element]) -> [Element] {
        userDefaults.object(forKey: key) as? [Element] ?? defaultValue
    }

    public static func retrieveOptional(from userDefaults: UserDefaults, key: String) -> [Element]? {
        userDefaults.object(forKey: key) as? [Element]
    }

    public func store(in userDefaults: UserDefaults, key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension Dictionary: UBPListValue where Key == String, Value: UBPListValue {}

extension Dictionary: UBUserDefaultValue where Key == String, Value: UBPListValue {
    public func store(in userDefaults: UserDefaults, key: String) {
        userDefaults.set(self, forKey: key)
    }
}
