//
//  FoodService.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import Foundation

class MealService {
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    
    // MARK: - Fetch All Meals
    func fetchFoods(completion: @escaping (Result<[Meal], Error>) -> Void) {
        request(endpoint: "search.php?s=", type: MealResponse.self) { result in
            completion(result.map { $0.meals ?? [] })
        }
    }
    
    // MARK: - Fetch Categories
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        request(endpoint: "categories.php", type: CategoryResponse.self) { result in
            completion(result.map { $0.categories ?? [] })
        }
    }
    
    // MARK: - Fetch Meals by Category
    func fetchMealsForCategory(for category: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        let path = "filter.php?c=\(category)"
        request(endpoint: path, type: MealResponse.self) { result in
            completion(result.map { $0.meals ?? [] })
        }
    }
    
    // MARK: - Fetch Meal Details by ID
    func fetchMealDetailById(by id: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        let path = "lookup.php?i=\(id)"
        request(endpoint: path, type: MealResponse.self) { result in
            completion(result.map { $0.meals ?? [] })
        }
    }
    
    // MARK: - Search Meal
    func searchMeal(with text: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        let path = "search.php?s=\(text)"
        request(endpoint: path, type: MealResponse.self) { result in
            completion(result.map { $0.meals ?? [] })
        }
    }
    
    // MARK: - Generic Request Method
    private func request<T: Decodable>(endpoint: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(MealServiceError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(MealServiceError.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - Custom Errors
enum MealServiceError: Error {
    case invalidURL
    case noData
}
