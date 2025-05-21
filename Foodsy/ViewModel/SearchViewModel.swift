//
//  SearchViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 17.05.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SearchViewModel {
    //MARK: - Properties
    private let mealService = MealService()
    
    private var searchMeals: [Meal] = []
    var onDataUpdated: (() -> Void)?
    
    func search(with text: String) {
        mealService.searchMeal(with: text) { [weak self] meals in
            switch meals {
            case .success(let meals):
                self?.searchMeals = meals
                DispatchQueue.main.async{
                    self?.onDataUpdated?()
                }
            case .failure(let failure):
                print(failure)
            case nil:
                return
            }
        }
    }
    
    func searchMeal(at index: Int) -> Meal {
        return searchMeals[index]
    }
    
    func numberOfMeals() -> Int {
        return searchMeals.count
    }
    
    func isResultEmpty() -> Bool {
        return searchMeals.isEmpty
    }
    
    func ingredients(for index: Int) -> [String] {
        let meal = searchMeals[index]
        var result: [String] = []

        let ingredientList = [
            meal.strIngredient1,
            meal.strIngredient2,
            meal.strIngredient3,
            meal.strIngredient4,
            meal.strIngredient5,
            meal.strIngredient6,
            meal.strIngredient7,
            meal.strIngredient8,
            meal.strIngredient9,
            meal.strIngredient10,
            meal.strIngredient11,
            meal.strIngredient12,
            meal.strIngredient13,
            meal.strIngredient14,
            meal.strIngredient15,
            meal.strIngredient16,
            meal.strIngredient17,
            meal.strIngredient18,
            meal.strIngredient19,
            meal.strIngredient20
        ]
        
        for ingredient in ingredientList {
            if let ingredient = ingredient,
               !ingredient.trimmingCharacters(in: .whitespaces).isEmpty {
                result.append(ingredient)
            }
        }
        return result
    }
    
    func addMealToFavorites(_ meal: Meal) {
        let db = Firestore.firestore()
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let mealData: [String: Any] = ["id": meal.idMeal,
                                       "imageUrl": meal.strMealThumb,
                                       "name": meal.strMeal]
        db.collection("users").document(currentUserId).collection("favorites").addDocument(data: mealData) { error in
            if let error = error {
                print("favorite saving failed.",
                      error.localizedDescription)
            }else {
                print("favorite saved succesfully.")
            }
        }
    }
}
