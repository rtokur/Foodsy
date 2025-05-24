//
//  AuthManager.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 20.05.2025.
//
import FirebaseAuth
import FirebaseFirestore

enum AuthError: Error {
    case userNotFound
    case dataFetchFailed(String)
    case missingFields
}

struct AuthManager {
    static func getCurrentUser(completion: @escaping (Result<UserModel, AuthError>) -> Void){
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.userNotFound))
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.dataFetchFailed(error.localizedDescription)))
                return
            }
            
            guard let data = snapshot?.data(),
                  let name = data["username"] as? String else {
                completion(.failure(.missingFields))
                return
            }
            
            let userModel = UserModel(uid: user.uid, email: user.email, name: name)
            completion(.success(userModel))
        }
    }
}
