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
    private let mealService: MealServiceProtocol
    private let favoriteService: FavoriteServiceProtocol
    private let user: UserModel
    
    var meal: Meal?
    var favoriteMeals: [Meal] = []
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Init
    init(meal: Meal,
         user: UserModel,
         favoriteService: FavoriteServiceProtocol = FavoriteService(),
         mealService: MealServiceProtocol = MealService()) {
        self.meal = meal
        self.user = user
        self.favoriteService = favoriteService
        self.mealService = mealService
    }
    
    init(mealId: String,
         user: UserModel,
         favoriteService: FavoriteServiceProtocol = FavoriteService(),
         mealService: MealServiceProtocol = MealService()){
        self.user = user
        self.favoriteService = favoriteService
        self.mealService = mealService
        fetchMealById(by: mealId)
    }
    
    // MARK: - Computed Properties
    var mealName: String {
        meal?.strMeal ?? "No name"
    }
    
    var imageURL: URL? {
        meal?.mealUrl
    }
    
    var category: String {
        meal?.strCategory ?? "Unknown"
    }
    
    var area: String {
        meal?.strArea ?? "Unknown"
    }
    
    var instructions: [String] {
        meal?.strInstructions?
            .components(separatedBy: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { "- \($0)." } ?? []
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
    
    // MARK: - Networking
    func fetchMealById(by id: String) {
        mealService.fetchMealDetailById(by: id) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meal = meals.first
                DispatchQueue.main.async {
                    self?.onDataUpdated?()
                }
            case .failure(let error):
                print("Error fetching meal: \(error.localizedDescription)")
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
    
    // MARK: - Favorite Logic
    func isFavorite(_ meal: Meal) -> Bool {
        favoriteMeals.contains(where: { $0.idMeal == meal.idMeal })
    }
    
    func toggleFavoriteState(for meal: Meal, completion: @escaping () -> Void) {
        if isFavorite(meal) {
            removeMealFromFavorites(meal,
                                    completion: completion)
        } else {
            addMealToFavorites(meal,
                               completion: completion)
        }
    }
    
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
        favoriteService.removeFavorite(meal, userId: user.uid) { [weak self] success in
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
