//
//  FoodViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MealViewModel{
    //MARK: - Properties
    private let mealService = MealService()
    
    var meals: [Meal] = []
    
    var categories: [Category] = []
    
    var onDataUpdated: (() -> Void)?
    
    let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    var userName: String {
        return user.name
    }
    
    //MARK: - Functions
    func loadMeals(){
        mealService.fetchFoods { [weak self] meals in
            guard let self = self else { return }
            self.meals = meals ?? []
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
    
    func loadCategories(){
        mealService.fetchCategories { [weak self] categories in
            guard let self = self else { return }
            self.categories = categories ?? []
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
    
    func meal(at index: Int) -> Meal{
        return meals[index]
    }
    
    func category(at index: Int) -> Category{
        return categories[index]
    }
    
    func numberOfCategories() -> Int{
        return categories.count
    }
    
    func numberOfMeals() -> Int{
        return meals.count
    }

    func numberOfIngredients(meal: Meal) -> Int{
        let mirror = Mirror(reflecting: meal)
        var count = 0
        
        for i in 1...20 {
            let ingredient = "strIngredient\(i)"
            if let value = mirror.children.first(where: { $0.label == ingredient})?.value as? String,
               !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                count += 1
            }
        }
        
        return count
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
