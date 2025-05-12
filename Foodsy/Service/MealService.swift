//
//  FoodService.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import Foundation

class MealService {
    //MARK: - Functions
    func fetchFoods(completion: @escaping([Meal]?) -> Void){
        let foodUrlString = "https://www.themealdb.com/api/json/v1/1/search.php?s="
        guard let foodUrl = URL(string: foodUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: foodUrl) { data, response, error in
            if let data = data{
                do{
                    let result = try JSONDecoder().decode(MealResponse.self,from: data)
                    let dataa = try JSONSerialization.jsonObject(with: data)
                    print(dataa)
                    completion(result.meals)
                }catch{
                    print(error)
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        }.resume()
    }
    
    func fetchCategories(completion: @escaping([Category]?) -> Void){
        let categoryUrlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        guard let categoryUrl = URL(string: categoryUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: categoryUrl) { data, response, error in
            if let data = data{
                do{
                    let result = try JSONDecoder().decode(CategoryResponse.self,from: data)
                    let dataa = try JSONSerialization.jsonObject(with: data)
                    print(dataa)
                    completion(result.categories ?? [])
                }catch{
                    print(error)
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        }.resume()
    }
    
}
