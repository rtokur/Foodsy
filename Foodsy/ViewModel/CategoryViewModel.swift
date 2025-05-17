//
//  CategoryViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 13.05.2025.
//

import Foundation

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
}
