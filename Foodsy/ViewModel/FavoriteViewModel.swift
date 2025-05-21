import FirebaseFirestore

class FavoriteViewModel {
    private(set) var allFavorites: [Meal] = []
    private let favoriteService = FavoriteService()
    var onDataUpdated: (() -> Void)?
    
    let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    var userName: String {
        return user.name
    }
    
    func fetchFavorites() {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("favorites").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("not taken favorites", error?.localizedDescription ?? "unknown error")
                return
            }
            
            self.allFavorites = documents.compactMap { doc in
                let data = doc.data()
                if let id = data["id"] as? String,
                   let imageUrl = data["imageUrl"] as? String,
                   let name = data["name"] as? String {
                    
                    return Meal(idMeal: id,
                                strMeal: name,
                                strMealThumb: imageUrl)
                }
                return nil
            }
            
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
    
    func getFavorites(at index: Int) -> Meal {
        return allFavorites[index]
    }
    
    func numberOfFavorites() -> Int {
        return allFavorites.count
    }
    
    func isMealFavorite(_ meal: Meal) -> Bool {
        return allFavorites.contains(where: { $0.idMeal == meal.idMeal })
    }
    
    func toggleFavorite(for meal: Meal) {
        if isMealFavorite(meal){
            favoriteService.removeFavorite(meal, userId: user.uid) { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.allFavorites.removeAll(where: { $0.idMeal == meal.idMeal })
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                    }
                }
            }
        }else {
            favoriteService.addFavorite(meal, userId: user.uid) { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.allFavorites.append(meal)
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                    }
                }
            }
        }
    }
}
