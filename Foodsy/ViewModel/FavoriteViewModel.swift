import Foundation
import FirebaseFirestore

class FavoriteViewModel {
    // MARK: - Properties
    private let favoriteService: FavoriteServiceProtocol
    let user: UserModel
    
    var favoriteMeals: [Meal] = []
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Init
    init(user: UserModel,
         favoriteService: FavoriteServiceProtocol = FavoriteService()) {
        self.user = user
        self.favoriteService = favoriteService
    }
    
    var userName: String {
        return user.name
    }
    
    // MARK: - Data Fetching
    func loadFavorites() {
        favoriteService.fetchFavorites(for: user.uid) { [weak self] favorites in
            self?.favoriteMeals = favorites
            DispatchQueue.main.async {
                self?.onDataUpdated?()
            }
        }
    }
    
    // MARK: - Accessors
    func meal(at index: Int) -> Meal {
        return favoriteMeals[index]
    }
    
    func numberOfFavorites() -> Int {
        return favoriteMeals.count
    }
    
    func isFavorite(_ meal: Meal) -> Bool {
        return favoriteMeals.contains(where: { $0.idMeal == meal.idMeal })
    }
    
    // MARK: - Favorite Operations
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
