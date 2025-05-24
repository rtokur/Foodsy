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
    // MARK: - Properties
    var selectedCategory: String? {
        didSet {
            fetchMealsForSelectedCategory()
        }
    }
    
    var meals: [Meal] = []
    var favoriteMeals: [Meal] = []
    var categories: [Category] = []
    
    private let mealService: MealServiceProtocol
    private let favoriteService: FavoriteServiceProtocol
    let user: UserModel
    
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Init
    init(user: UserModel,
         mealService: MealServiceProtocol = MealService(),
         favoriteService: FavoriteServiceProtocol = FavoriteService()) {
        self.user = user
        self.mealService = mealService
        self.favoriteService = favoriteService
    }
    
    // MARK: - Data Fetching
    func fetchMealsForSelectedCategory() {
        guard let category = selectedCategory else { return }
        
        mealService.fetchMealsForCategory(for: category) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let meals):
                self.meals = meals
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let error):
                print("⚠️ Failed to fetch meals:", error)
            }
        }
    }
    
    func fetchCategories() {
        mealService.fetchCategories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let error):
                print("⚠️ Failed to fetch categories:", error)
            }
        }
    }
    
    func loadFavorites(completion: @escaping () -> Void) {
        favoriteService.fetchFavorites(for: user.uid) { [weak self] favorites in
            self?.favoriteMeals = favorites
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: - Accessors
    func meal(at index: Int) -> Meal {
        return meals[index]
    }
    
    var numberOfMeals: Int {
        return meals.count
    }
    
    func indexOfFirstMealInSelectedCategory() -> Int? {
        return meals.firstIndex { $0.strCategory == selectedCategory }
    }
    
    func isFavorite(_ meal: Meal) -> Bool {
        return favoriteMeals.contains { $0.idMeal == meal.idMeal }
    }
    
    // MARK: - Favorite Management
    func toggleFavoriteState(for meal: Meal, completion: @escaping () -> Void) {
        if isFavorite(meal) {
            removeMealFromFavorites(meal, completion: completion)
        } else {
            addMealToFavorites(meal, completion: completion)
        }
    }
    
    func addMealToFavorites(_ meal: Meal, completion: @escaping () -> Void) {
        favoriteService.addFavorite(meal, userId: user.uid) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.favoriteMeals.append(meal)
            }
            DispatchQueue.main.async {
                self.onDataUpdated?()
                completion()
            }
        }
    }
    
    func removeMealFromFavorites(_ meal: Meal, completion: @escaping () -> Void) {
        favoriteService.removeFavorite(meal, userId: user.uid) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.favoriteMeals.removeAll { $0.idMeal == meal.idMeal }
            }
            DispatchQueue.main.async {
                self.onDataUpdated?()
                completion()
            }
        }
    }
}
