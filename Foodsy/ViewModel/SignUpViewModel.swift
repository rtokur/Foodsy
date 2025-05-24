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
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    
    func register(name: String,
                  email: String,
                  password: String,
                  completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                completion(.failure(.dataFetchFailed(error.localizedDescription)))
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.failure(.userNotFound))
                return
            }
            
            let userData: [String: Any] = ["email": email,
                            "username": name]
            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(.dataFetchFailed(error.localizedDescription)))
                    return
                }
                
                let userModel = UserModel(uid: uid,
                                          email: email,
                                          name: name)
                completion(.success(userModel))
            }
        }
    }
}
