//
//  FavoriteService.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 21.05.2025.
//

import Foundation
import FirebaseFirestore

//MARK: - Protocol
protocol FavoriteServiceProtocol {
    func addFavorite(_ meal: Meal,
                     userId: String,
                     completion: @escaping (Bool) -> Void)
    func removeFavorite(_ meal: Meal,
                        userId: String,
                        completion: @escaping (Bool) -> Void)
    func fetchFavorites(for userId: String,
                        completion: @escaping ([Meal]) -> Void)
}

class FavoriteService: FavoriteServiceProtocol {
    private let db = Firestore.firestore()
    
    //MARK: - Functions
    func addFavorite(_ meal: Meal,
                     userId: String,
                     completion: @escaping (Bool) -> Void) {
        guard let id = meal.idMeal,
              let imageUrl = meal.strMealThumb,
              let name = meal.strMeal else {
            completion(false)
            return
        }
        
        let mealData: [String: Any] = ["id": id,
                                       "imageUrl": imageUrl,
                                       "name": name]
        db.collection("users").document(userId).collection("favorites").document(id).setData(mealData) { error in
            completion(error == nil)
        }
        
    }
    
    func removeFavorite(_ meal: Meal,
                        userId: String,
                        completion: @escaping (Bool) -> Void) {
        guard let id = meal.idMeal else {
            completion(false)
            return
        }
        db.collection("users").document(userId).collection("favorites").document(id).delete(completion: { error in
            completion(error == nil)
        })
    }
    
    func fetchFavorites(for userId: String, completion: @escaping ([Meal]) -> Void) {
        db.collection("users").document(userId).collection("favorites").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                completion([])
                return
            }
            
            let meals = documents.compactMap { doc -> Meal? in
                let data = doc.data()
                guard let id = data["id"] as? String,
                      let name = data["name"] as? String,
                      let imageUrl = data["imageUrl"] as? String else {
                    return nil
                }
                return Meal(idMeal: id, strMeal: name, strMealThumb: imageUrl)
            }
            
            completion(meals)
        }
    }
}
