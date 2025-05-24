//
//  LoginViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 23.05.2025.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    func login(email: String, password: String, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            if let error = error {
                completion(.failure(.dataFetchFailed(error.localizedDescription)))
                return
            }
            AuthManager.getCurrentUser(completion: completion)
        }
    }
}
