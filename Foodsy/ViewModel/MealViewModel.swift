//
//  FoodViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import Foundation

class MealViewModel{
    //MARK: - Properties
    private let mealService = MealService()
    
    var meals: [Meal] = []
    
    var categories: [String: String] = [:]
    
    var onDataUpdated: (() -> Void)?
    
    //MARK: - Functions
    func loadMeals(){
        mealService.fetchFoods { [weak self] meals in
            guard let self = self else { return }
            self.meals = meals ?? []
            self.loadCategories()
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
    
    func loadCategories(){
        var categorySet: Set<String> = []
        meals.forEach { meal in
            if let mealCategory = meal.strCategory{
                categorySet.insert(mealCategory)
                
                if categories[mealCategory] == nil, let thumb = meal.strMealThumb {
                    categories[mealCategory] = thumb
                }
            }
        }
        
    }
    
    func meal(at index: Int) -> Meal{
        return meals[index]
    }
    
    func category(at index: Int) -> String{
        return Array(categories.keys)[index]
    }
    
    func numberOfCategories() -> Int{
        return categories.count
    }
    
    func numberOfMeals() -> Int{
        return meals.count
    }

}
