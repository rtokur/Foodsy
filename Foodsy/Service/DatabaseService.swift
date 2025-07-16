//
//  DatabaseService.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 11.07.2025.
//
import FirebaseFirestore

protocol UserDatabaseServiceProtocol {
    func saveUser(uid: String, name: String, email: String, completion: @escaping (Result<UserModel, AuthError>) -> Void)
    func fetchUser(uid: String, completion: @escaping (Result<UserModel, AuthError>) -> Void)
}

class FirebaseUserDatabaseService: UserDatabaseServiceProtocol {
    private let db = Firestore.firestore()

    func saveUser(uid: String, name: String, email: String, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        let userData: [String: Any] = ["username": name, "email": email]

        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                completion(.failure(.firestoreError(error.localizedDescription)))
            } else {
                let user = UserModel(uid: uid, email: email, name: name)
                completion(.success(user))
            }
        }
    }

    func fetchUser(uid: String, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.firestoreError(error.localizedDescription)))
                return
            }

            guard let data = snapshot?.data(),
                  let name = data["username"] as? String,
                  let email = data["email"] as? String else {
                completion(.failure(.missingFields))
                return
            }

            let user = UserModel(uid: uid, email: email, name: name)
            completion(.success(user))
        }
    }
}
