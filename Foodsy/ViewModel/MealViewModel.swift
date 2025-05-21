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
    private let mealService = MealService()
    
    var meals: [Meal] = []
    
    var categories: [Category] = []
    
    var onDataUpdated: (() -> Void)?
    var favoriteMeals: [Meal] = []
    
    let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    var userName: String {
        return user.name
    }
    
    //MARK: - Functions
    func loadMeals(){
        mealService.fetchFoods { [weak self] meals in
            guard let self = self else { return }
            self.meals = meals ?? []
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
    
    func loadCategories(){
        mealService.fetchCategories { [weak self] categories in
            guard let self = self else { return }
            self.categories = categories ?? []
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
    
    func meal(at index: Int) -> Meal{
        return meals[index]
    }
    
    func category(at index: Int) -> Category{
        return categories[index]
    }
    
    func numberOfCategories() -> Int{
        return categories.count
    }
    
    func numberOfMeals() -> Int{
        return meals.count
    }

    func numberOfIngredients(meal: Meal) -> Int{
        let mirror = Mirror(reflecting: meal)
        var count = 0
        
        for i in 1...20 {
            let ingredient = "strIngredient\(i)"
            if let value = mirror.children.first(where: { $0.label == ingredient})?.value as? String,
               !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                count += 1
            }
        }
        
        return count
    }
    
    func toggleFavoriteState(for meal: Meal, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        guard let id = meal.idMeal else { return }

        if isFavorite(meal) {
            removeMealFromFavorites(meal) {
                completion()
            }
        } else {
            addMealToFavorites(meal) {
                completion()
            }
        }
        
    }
    
    func addMealToFavorites(_ meal: Meal, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        if let id = meal.idMeal,
           let imageUrl = meal.strMealThumb,
           let name = meal.strMeal{
            let mealData: [String: Any] = ["id": id,
                                           "imageUrl": imageUrl,
                                           "name": name]
            db.collection("users").document(user.uid).collection("favorites").document(id).setData(mealData) { error in
                if let error = error {
                    print("favorite saving failed.",
                          error.localizedDescription)
                    completion()
                }else {
                    print("favorite saved succesfully.")
                    self.favoriteMeals.append(meal)
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                        completion()
                    }
                }
            }
        }
    }
    
    func removeMealFromFavorites(_ meal: Meal, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        if let id = meal.idMeal{
            db.collection("users").document(user.uid).collection("favorites").document(id).delete() { error in
                if let error = error {
                    print("favorite deleting failed.",
                          error.localizedDescription)
                    completion()
                }else {
                    print("favorite deleted succesfully.")
                    self.favoriteMeals.removeAll(where: { $0.idMeal == id })
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                        completion()
                    }
                }
            }
        }
    }
    
    func isFavorite(_ meal: Meal) -> Bool {
        return favoriteMeals.contains(where: { $0.idMeal == meal.idMeal })
    }
    
    func loadFavorites(completion: @escaping () -> Void){
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("favorites").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("favorites couldnt be loaded:", error?.localizedDescription ?? "")
                completion()
                return
            }
            
            self.favoriteMeals = documents.compactMap({ doc in
                let data = doc.data()
                guard let id = data["id"] as? String,
                      let name = data["name"] as? String,
                      let imageUrl = data["imageUrl"] as? String else { return nil }
                return Meal(idMeal: id, strMeal: name, strMealThumb: imageUrl)
            })
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
