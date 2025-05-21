//
//  CategoryViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 13.05.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CategoryViewModel {
    //MARK: - Properties
    var selectedCategory: String? {
        didSet {
            fetchMeals()
        }
    }
    var meals: [Meal] = []
    var categories: [Category] = []
    private let mealService = MealService()
    var onDataUpdated: (() -> Void)?
    
    //MARK: - Functions
    func fetchMeals(){
        guard let category = selectedCategory else { return }
        mealService.fetchMealsForCategory(for: category) { result in
            switch result {
            case .success(let meals):
                self.meals = meals
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let error):
                print(error)
            case .none:
                return
            }
        }
    }
    
    func fetchCategories(){
        mealService.fetchCategories { [weak self] categories in
            guard let self = self, let categories = categories else { return }
            DispatchQueue.main.async {
                self.categories = categories
                self.onDataUpdated?()
            }
        }
    }
    
    func meal(at index: Int) -> Meal{
        return meals[index]
    }
    
    var numberOfMeals: Int{
        return meals.count
    }
    
    func indexOfFirstMealInSelectedCategory() -> Int? {
        return meals.firstIndex { $0.strCategory == selectedCategory }
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
