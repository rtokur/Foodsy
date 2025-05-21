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
    var favoriteMeals: [Meal] = []
    var categories: [Category] = []
    private let mealService = MealService()
    var onDataUpdated: (() -> Void)?
    private let favoriteService: FavoriteServiceProtocol
    private let user: UserModel
    
    init(user: UserModel, favoriteService: FavoriteServiceProtocol = FavoriteService()) {
        self.user = user
        self.favoriteService = favoriteService
    }
    
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
    
    func isFavorite(_ meal: Meal) -> Bool {
        return favoriteMeals.contains(where: { $0.idMeal == meal.idMeal })
    }
    
    func addMealToFavorites(_ meal: Meal, completion: @escaping (Bool) -> Void) {
        favoriteService.addFavorite(meal, userId: user.uid) { success in
            if success {
                print("Meal added to favorites")
            } else {
                print("Failed to add to favorites")
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func loadFavorites(completion: @escaping () -> Void) {
        favoriteService.fetchFavorites(for: user.uid) { [weak self] meals in
            self?.favoriteMeals = meals
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
