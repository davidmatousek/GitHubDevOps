//
//  KeychainHelper.swift
//  GitHubDevOps
//
//  Secure storage for sensitive data using iOS Keychain
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    private let service = "com.alphafish.GitHubDevOps"
    
    enum KeychainError: Error {
        case noData
        case unexpectedData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: - Save Token
    func save(_ data: Data, for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func save(_ string: String, for key: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw KeychainError.unexpectedData
        }
        try save(data, for: key)
    }
    
    // MARK: - Retrieve Token
    func retrieve(for key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.noData
            } else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        
        guard let data = result as? Data else {
            throw KeychainError.unexpectedData
        }
        
        return data
    }
    
    func retrieveString(for key: String) throws -> String {
        let data = try retrieve(for: key)
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedData
        }
        return string
    }
    
    // MARK: - Delete Token
    func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}

// MARK: - Convenience Methods for App
extension KeychainHelper {
    private enum Keys {
        static let bearerToken = "BearerToken"
    }
    
    func saveBearerToken(_ token: String) {
        do {
            try save(token, for: Keys.bearerToken)
        } catch {
            print("Failed to save bearer token to Keychain: \(error)")
        }
    }
    
    func getBearerToken() -> String? {
        do {
            return try retrieveString(for: Keys.bearerToken)
        } catch KeychainError.noData {
            return nil
        } catch {
            print("Failed to retrieve bearer token from Keychain: \(error)")
            return nil
        }
    }
    
    func deleteBearerToken() {
        do {
            try delete(for: Keys.bearerToken)
        } catch {
            print("Failed to delete bearer token from Keychain: \(error)")
        }
    }
}