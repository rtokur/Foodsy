//
//  AuthManager.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 20.05.2025.
//
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

enum AuthError: Error {
    case userNotFound
    case firebaseError(String)
    case firestoreError(String)
    case googleSignInFailed(String)
    case githubSignInFailed(String)
    case missingToken
    case missingCredential
    case missingFields
    case signOutFailed(String)
}

protocol AuthManagerProtocol {
    func login(email: String, password: String, completion: @escaping (Result<UserModel, AuthError>) -> Void)
    func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<UserModel, AuthError>) -> Void)
    func signOut(completion: @escaping (Result<Void, AuthError>) -> Void)
    func createUser(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void)
}

class AuthManager: AuthManagerProtocol {
    
    static let shared = AuthManager()
    
    func login(email: String, password: String, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(.firebaseError(error.localizedDescription)))
                return
            }
            self.getCurrentUser(completion: completion)
        }
    }
    
    func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(.googleSignInFailed(error.localizedDescription)))
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(.missingToken))
                return
            }

            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    completion(.failure(.firebaseError(error.localizedDescription)))
                    return
                }
                self.getCurrentUser(completion: completion)
            }
        }
    }

    func signOut(completion: @escaping (Result<Void, AuthError>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(.signOutFailed(error.localizedDescription)))
        }
    }

    func getCurrentUser(completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.userNotFound))
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.firestoreError(error.localizedDescription)))
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
    
    func createUser(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(.failure(.firebaseError(error.localizedDescription)))
                    return
                }
                guard let uid = result?.user.uid else {
                    completion(.failure(.userNotFound))
                    return
                }
                completion(.success(uid))
            }
        }
}
