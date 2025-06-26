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
    func login(email: String,
               password: String,
               completion: @escaping (Result<UserModel,
                                      AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            if let error = error {
                completion(.failure(.dataFetchFailed(error.localizedDescription)))
                return
            }
            AuthManager.getCurrentUser(completion: completion)
        }
    }
    
    func loginWithGoogle(presenting viewController: UIViewController,
                         completion: @escaping (Result<UserModel,
                                                AuthError>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(.dataFetchFailed(error.localizedDescription)))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(.dataFetchFailed("Google id validation tokens not taken.")))
                return
            }

            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(.dataFetchFailed(error.localizedDescription)))
                    return
                }
                
                AuthManager.getCurrentUser(completion: completion)
            }
        }
    }
    
    func loginWithGitHub(completion: @escaping (Result<UserModel,
                                                AuthError>) -> Void) {
        let provider = OAuthProvider(providerID: "github.com")
        
        provider.getCredentialWith(nil) { credential, error in
            if let error = error {
                completion(.failure(.dataFetchFailed("Github login failed: \(error.localizedDescription)")))
                return
            }
            
            guard let credential = credential else {
                completion(.failure(.dataFetchFailed("Github credential is nil.")))
                return
            }
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(.dataFetchFailed("Firebase sign-in failed: \(error.localizedDescription)")))
                    return
                }
                
                AuthManager.getCurrentUser(completion: completion)
            }
        }
    }
}
