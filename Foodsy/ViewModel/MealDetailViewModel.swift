//
//  MealDetailViewModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 9.05.2025.
//

import Foundation

class MealDetailViewModel {
    //MARK: - Properties
    let meal: Meal
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    var mealName: String {
        return meal.strMeal ?? "No name"
    }
    
    var imageURL: URL? {
        return meal.mealUrl
    }
    
    var instructions: [String] {
        let splittedInstructions = meal.strInstructions?.components(separatedBy: ".") ?? []
        
        let arrangedInstructions = splittedInstructions
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }  
            .filter { !$0.isEmpty }
            .map { "- \($0)." }

        return arrangedInstructions
    }
    
    var category: String {
        return meal.strCategory ?? "Unknown"
    }
    
    var area: String {
        return meal.strArea ?? "Unknown"
    }
    
    var ingredients: [String] {
        var result: [String] = []
        let mirror = Mirror(reflecting: meal)
        for i in 1...20{
            let ingredientFirst = "strIngredient\(i)"
            let measureFirst = "strMeasure\(i)"
            
            if let ingredient = mirror.children.first(where: { $0.label == ingredientFirst})?.value as? String,
               let measure = mirror.children.first(where: { $0.label == measureFirst})?.value as? String,
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                result.append("- \(measure) \(ingredient)")
            }
        }
        return result
    }
}
