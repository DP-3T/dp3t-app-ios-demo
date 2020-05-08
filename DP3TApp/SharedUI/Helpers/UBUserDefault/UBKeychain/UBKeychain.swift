/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation

/// Convenience wrapper for Keychain
public class UBKeychain {
    /// Sets an item in the Keychain.
    ///
    /// - Parameters:
    ///     - value: The value to be set
    ///     - key: The key referring to the value
    ///     - accessibility: Determines where the value can be accessed
    /// - Returns: Whether setting the value succeded
    @discardableResult
    public static func set(_ value: String, key: String, accessibility: UBKeychainAccessibility) -> Bool {
        guard let data = value.data(using: .utf8, allowLossyConversion: false) else {
            return false
        }
        return UBKeychain.set(data, key: key, accessibility: accessibility)
    }

    /// :nodoc:
    @discardableResult
    static func set(_ value: Data, key: String, accessibility: UBKeychainAccessibility) -> Bool {
        let query = [
            kSecAttrAccount as String: key,
            kSecValueData as String: value,
            kSecAttrAccessible as String: accessibility.rawValue,
            // We use genericPassword instead of internet password because
            // the value is not assiciated with a server
            kSecClass as String: kSecClassGenericPassword,
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Retrieves an item from the Keychain
    ///
    /// - Parameters:
    ///     - key: The key referring to the value
    /// - Returns: The value, if it exists
    public static func get(_ key: String) -> String? {
        guard let data = getData(key) else {
            return nil
        }
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }

    /// :nodoc:
    static func getData(_ key: String) -> Data? {
        let query = [
            kSecAttrAccount as String: key,
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ] as [String: Any]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            return result as? Data
        } else {
            return nil
        }
    }

    /// Delete a specific item in the Keychain.
    /// - Parameters:
    ///     - key: The key referring to the value
    /// - Returns: Whether deleting the value succeded
    public static func delete(_ key: String) -> Bool {
        let query = [
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    /// Deletes all of the items in the keychain.
    /// iOS sometimes fails to delete all the items as the app is uninstalled, which results
    ///
    /// The app may choose to delete all the items to prevent undesirable behaviour.
    ///
    /// - Returns: Whether deleting the value succeded
    public static func deleteAllItems() -> Bool {
        let secClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity,
        ]
        return secClasses.allSatisfy { secClass in
            let query: NSDictionary = [kSecClass as String: secClass]
            let status = SecItemDelete(query as CFDictionary)
            return status == errSecSuccess || status == errSecItemNotFound
        }
    }
}
