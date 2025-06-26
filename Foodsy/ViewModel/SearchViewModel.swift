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
    // MARK: - Dependencies
    private let mealService: MealServiceProtocol
    private let favoriteService: FavoriteServiceProtocol
    private(set) var searchMeals: [Meal] = []
    private(set) var favoriteMeals: [Meal] = []
    
    let user: UserModel
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Init
    init(user: UserModel,
         favoriteService: FavoriteServiceProtocol = FavoriteService(),
         mealService: MealServiceProtocol = MealService()
         ) {
        self.user = user
        self.favoriteService = favoriteService
        self.mealService = mealService
    }
    
    // MARK: - Search Logic
    func search(with text: String) {
        mealService.searchMeal(with: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let meals):
                self.searchMeals = meals
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let error):
                print("Search failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Accessors
    func numberOfMeals() -> Int {
        return searchMeals.count
    }
    
    func searchMeal(at index: Int) -> Meal {
        return searchMeals[index]
    }
    
    func isResultEmpty() -> Bool {
        return searchMeals.isEmpty
    }
    
    func ingredients(for index: Int) -> [String] {
        let meal = searchMeals[index]
        return (1...20).compactMap { i in
            let key = "strIngredient\(i)"
            if let ingredient = Mirror(reflecting: meal).children.first(where: { $0.label == key })?.value as? String,
               !ingredient.trimmingCharacters(in: .whitespaces).isEmpty {
                return ingredient
            }
            return nil
        }
    }

    // MARK: - Favorites
    func isFavorite(_ meal: Meal) -> Bool {
        return favoriteMeals.contains(where: { $0.idMeal == meal.idMeal })
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

    func toggleFavoriteState(for meal: Meal, completion: @escaping () -> Void) {
        if isFavorite(meal) {
            removeMealFromFavorites(meal, completion: completion)
        } else {
            addMealToFavorites(meal, completion: completion)
        }
    }
    
    private func addMealToFavorites(_ meal: Meal, completion: @escaping () -> Void) {
        favoriteService.addFavorite(meal, userId: user.uid) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.favoriteMeals.append(meal)
            }else{
                print("eklenemedi")
            }
            DispatchQueue.main.async {
                self.onDataUpdated?()
                completion()
            }
        }
    }
    
    private func removeMealFromFavorites(_ meal: Meal, completion: @escaping () -> Void) {
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
