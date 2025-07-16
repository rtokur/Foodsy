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
    private let mealService: MealServiceProtocol
    private let favoriteService: FavoriteServiceProtocol
    private let authService: AuthManagerProtocol
    var meals: [Meal] = []
    var categories: [Category] = []
    var favoriteMeals: [Meal] = []
    
    let user: UserModel
    var onDataUpdated: (() -> Void)?
    var onLogout: (() -> Void)?
    var onLogoutError: ((String) -> Void)?
    
    var userName: String {
        return user.name
    }
    
    // MARK: - Init
    init(user: UserModel,
         favoriteService: FavoriteServiceProtocol = FavoriteService(),
         mealService: MealServiceProtocol = MealService(),
         authService: AuthManagerProtocol = AuthManager.shared) {
        self.user = user
        self.favoriteService = favoriteService
        self.mealService = mealService
        self.authService = authService
    }
    
    // MARK: - Public Methods
    func loadMeals(){
        mealService.fetchFoods { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let meals):
                self.meals = meals
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func loadCategories(){
        mealService.fetchCategories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func loadFavorites(completion: @escaping () -> Void) {
        favoriteService.fetchFavorites(for: user.uid) { [weak self] meals in
            guard let self = self else { return }
            self.favoriteMeals = meals
            DispatchQueue.main.async {
                completion()
                self.onDataUpdated?()
            }
        }
    }
    
    func logOut() {
        authService.signOut { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.onLogout?()
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.onLogoutError?(failure.localizedDescription)
                }
            }
        }
    }
    
    func toggleFavorite(for meal: Meal,
                             completion: @escaping () -> Void) {
        if isFavorite(meal) {
            removeMealFromFavorites(meal,
                                    completion: completion)
        } else {
            addMealToFavorites(meal,
                               completion: completion)
        }
    }
    
    func isFavorite(_ meal: Meal) -> Bool {
        return favoriteMeals.contains(where: { $0.idMeal == meal.idMeal })
    }
    
    func numberOfIngredients(for meal: Meal) -> Int {
        let mirror = Mirror(reflecting: meal)
        return (1...20).reduce(0) { count, i in
            let key = "strIngredient\(i)"
            if let value = mirror.children.first(where: { $0.label == key })?.value as? String,
               !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return count + 1
            }
            return count
        }
    }
    
    func numberOfMeals() -> Int{
        return meals.count
    }
    
    func numberOfCategories() -> Int{
        return categories.count
    }
    
    func meal(at index: Int) -> Meal{
        return meals[index]
    }
    
    func category(at index: Int) -> Category{
        return categories[index]
    }
    
    // MARK: - Favorite Helpers
    func addMealToFavorites(_ meal: Meal, completion: @escaping () -> Void) {
        favoriteService.addFavorite(meal,
                                    userId: user.uid) { [weak self] success in
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
        favoriteService.removeFavorite(meal,
                                       userId: user.uid) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.favoriteMeals.removeAll(where: { $0.idMeal == meal.idMeal })
            }
            DispatchQueue.main.async {
                self.onDataUpdated?()
                completion()
            }
        }
    }
}
