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
    
    var onDataUpdated: (() -> Void)?
    
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
    
    func numberOfMeals() -> Int{
        return meals.count
    }
    
    func meal(at index: Int) -> Meal{
        return meals[index]
    }
}
