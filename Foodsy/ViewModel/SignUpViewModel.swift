//
//  SignUpViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 24.05.2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel {
    private let authManager: AuthManagerProtocol
    private let userDB: UserDatabaseServiceProtocol

    init(authManager: AuthManagerProtocol = AuthManager(),
         userDB: UserDatabaseServiceProtocol = FirebaseUserDatabaseService()) {
        self.authManager = authManager
        self.userDB = userDB
    }

    func register(name: String,
                  email: String,
                  password: String,
                  completion: @escaping (Result<UserModel, AuthError>) -> Void) {

        authManager.createUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let uid):
                self?.userDB.saveUser(uid: uid, name: name, email: email, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
