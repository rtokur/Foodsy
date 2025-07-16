//
//  LoginViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 23.05.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

class LoginViewModel {
    private let authManager: AuthManagerProtocol

    init(authManager: AuthManagerProtocol = AuthManager.shared) {
        self.authManager = authManager
    }
    
    func login(email: String, password: String, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        authManager.login(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        authManager.loginWithGoogle(presenting: viewController) { result in
            completion(result)
        }
    }
    
    func signOut(completion: @escaping (Result<Void, AuthError>) -> Void) {
        authManager.signOut(completion: completion)
    }
}
