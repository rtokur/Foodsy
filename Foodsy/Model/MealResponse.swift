//
//  FoodModel.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import Foundation

class MealResponse: Codable {
    let meals: [Meal]?
}

class Meal: Codable{
    let idMeal: String?
    let strMeal: String?
    let strMealThumb: String?
    let strInstructions: String?
    let strCategory: String?
    let strArea: String?
    
    var mealUrl: URL? {
        guard let url = strMealThumb else { return nil }
        return URL(string: url)
    }
}
