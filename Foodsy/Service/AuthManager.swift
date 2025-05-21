//
//  AuthManager.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 20.05.2025.
//
import FirebaseAuth
import FirebaseFirestore

struct AuthManager {
    static func getCurrentUser(completion: @escaping (UserModel?) -> Void){
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data(),
                  let name = data["username"] as? String else {
                completion(nil)
                return
            }
            
            let userModel = UserModel(uid: user.uid, email: user.email, name: name)
            completion(userModel)
        }
    }
}
