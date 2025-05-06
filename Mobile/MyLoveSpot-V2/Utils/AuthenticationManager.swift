import SwiftUI
import Foundation
import Security

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var accessToken: String? = nil
    private var refreshToken: String? = nil
    
    private let accessTokenKey = "access_token"
    private let refreshTokenKeychainKey = "com.mylovespot.refreshtoken"
    
    init() {
        self.accessToken = UserDefaults.standard.string(forKey: accessTokenKey)
        self.refreshToken = getRefreshTokenFromKeychain()
        self.isAuthenticated = self.accessToken != nil
    }

    func getJWTToken() -> String? {
        return self.accessToken
    }

    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:3000/user/login") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        
                        if let token = json?["token"] as? String {
                            self.accessToken = token
                            UserDefaults.standard.set(token, forKey: self.accessTokenKey)
                            self.isAuthenticated = true
                            
                            if let refreshToken = json?["refreshToken"] as? String {
                                self.saveRefreshTokenToKeychain(token: refreshToken)
                            }
                            
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = self.refreshToken,
              let url = URL(string: "http://localhost:3000/user/refresh-token") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        
                        if let newAccessToken = json?["token"] as? String {
                            self.accessToken = newAccessToken
                            UserDefaults.standard.set(newAccessToken, forKey: self.accessTokenKey)
                            self.isAuthenticated = true
                            
                            if let newRefreshToken = json?["refreshToken"] as? String {
                                self.saveRefreshTokenToKeychain(token: newRefreshToken)
                            }
                            
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:3000/user/register") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["name": name, "email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        if let httpResponse = response as? HTTPURLResponse,
                           (200...299).contains(httpResponse.statusCode) {
                            
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                            
                            if let token = json?["token"] as? String {
                                self.accessToken = token
                                UserDefaults.standard.set(token, forKey: self.accessTokenKey)
                                self.isAuthenticated = true
                                
                                if let refreshToken = json?["refreshToken"] as? String {
                                    self.saveRefreshTokenToKeychain(token: refreshToken)
                                }
                            }
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    func logout() {
        guard let url = URL(string: "http://localhost:3000/user/logout"),
              let refreshToken = self.refreshToken else {
            print("Invalid URL or missing refresh token.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["token": refreshToken]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode logout body: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Logout request failed: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Logout failed with status code: \(httpResponse.statusCode)")
                return
            }

            DispatchQueue.main.async {
                self.accessToken = nil
                self.refreshToken = nil
                self.isAuthenticated = false
                
                UserDefaults.standard.removeObject(forKey: self.accessTokenKey)
                self.deleteRefreshTokenFromKeychain()
            }
        }.resume()
    }
    
    private func saveRefreshTokenToKeychain(token: String) {
        self.refreshToken = token

        deleteRefreshTokenFromKeychain()
        
        guard let tokenData = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: refreshTokenKeychainKey,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving refresh token to Keychain: \(status)")
        }
    }
    
    private func getRefreshTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: refreshTokenKeychainKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }
    
    private func deleteRefreshTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: refreshTokenKeychainKey
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
