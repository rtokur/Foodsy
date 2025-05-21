//
//  MealDetailViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 9.05.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MealDetailViewModel {
    //MARK: - Properties
    var meal: Meal?
    private var mealService = MealService()
    var onDataUpdated: (() -> Void)?
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    init(mealId: String){
        fetchMealById(by: mealId)
    }
    
    var mealName: String {
        return meal?.strMeal ?? "No name"
    }
    
    var imageURL: URL? {
        return meal?.mealUrl
    }
    
    var instructions: [String] {
        let splittedInstructions = meal?.strInstructions?.components(separatedBy: ".") ?? []
        
        let arrangedInstructions = splittedInstructions
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }  
            .filter { !$0.isEmpty }
            .map { "- \($0)." }

        return arrangedInstructions
    }
    
    var category: String {
        return meal?.strCategory ?? "Unknown"
    }
    
    var area: String {
        return meal?.strArea ?? "Unknown"
    }
    
    var ingredients: [String] {
        guard let meal = meal else { return [] }
        var result: [String] = []
        
        let ingredientList = [
            (meal.strIngredient1, meal.strMeasure1),
            (meal.strIngredient2, meal.strMeasure2),
            (meal.strIngredient3, meal.strMeasure3),
            (meal.strIngredient4, meal.strMeasure4),
            (meal.strIngredient5, meal.strMeasure5),
            (meal.strIngredient6, meal.strMeasure6),
            (meal.strIngredient7, meal.strMeasure7),
            (meal.strIngredient8, meal.strMeasure8),
            (meal.strIngredient9, meal.strMeasure9),
            (meal.strIngredient10, meal.strMeasure10),
            (meal.strIngredient11, meal.strMeasure11),
            (meal.strIngredient12, meal.strMeasure12),
            (meal.strIngredient13, meal.strMeasure13),
            (meal.strIngredient14, meal.strMeasure14),
            (meal.strIngredient15, meal.strMeasure15),
            (meal.strIngredient16, meal.strMeasure16),
            (meal.strIngredient17, meal.strMeasure17),
            (meal.strIngredient18, meal.strMeasure18),
            (meal.strIngredient19, meal.strMeasure19),
            (meal.strIngredient20, meal.strMeasure20)
        ]
        
        for (ingredient, measure) in ingredientList {
            if let ingredient = ingredient, !ingredient.trimmingCharacters(in: .whitespaces).isEmpty {
                let cleanMeasure = measure?.trimmingCharacters(in: .whitespaces) ?? ""
                result.append("- \(cleanMeasure) \(ingredient)")
            }
        }
        return result
    }
    
    func fetchMealById(by id: String){
        mealService.fetchMealDetailById(by: id) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meal = meals.first
                DispatchQueue.main.async {
                    self?.onDataUpdated?()
                }
            case .failure(let error):
                print(error)
            case .none:
                return
            }
        }
    }
    
    func addMealToFavorites(_ meal: Meal) {
        let db = Firestore.firestore()
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        if let id = meal.idMeal,
           let imageUrl = meal.strMealThumb,
           let name = meal.strMeal{
            let mealData: [String: Any] = ["id": id,
                                           "imageUrl": imageUrl,
                                           "name": name]
            db.collection("users").document(currentUserId).collection("favorites").document(id).setData(mealData) { error in
                if let error = error {
                    print("favorite saving failed.",
                          error.localizedDescription)
                }else {
                    print("favorite saved succesfully.")
                }
            }
        }
        
    }
}
