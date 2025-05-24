//
//  FavoriteViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 21.05.2025.
//

import UIKit

class FavoriteViewController: UIViewController {
    //MARK: - Properties
    var favoriteViewModel: FavoriteViewModel
    
    init(favoriteViewModel: FavoriteViewModel) {
        self.favoriteViewModel = favoriteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let categories: [Category] = []
    
    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"),
                        for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.addTarget(self,
                         action: #selector(backButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private let favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite Recipes"
        label.font = .boldSystemFont(ofSize: 23)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170,
                                 height: 220)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()

        favoriteViewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.favoriteCollectionView.reloadData()
                self.favoriteCollectionView.snp.updateConstraints { make in
                    make.height.equalTo(self.favoriteCollectionView.collectionViewLayout.collectionViewContentSize.height)
                }
            }
        }
        favoriteViewModel.loadFavorites {}
    }

    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(favoriteLabel)
        view.addSubview(favoriteCollectionView)
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        favoriteLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        favoriteCollectionView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    //MARK: - Actions
    @objc func backButtonTapped(_ sender: UIButton){
        dismiss(animated: true)
    }
}

//MARK: - Delegates
extension FavoriteViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return favoriteViewModel.favoriteMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell",
                                                      for: indexPath) as! FavoriteCollectionViewCell
        let meal = favoriteViewModel.meal(at: indexPath.row)
        let isFavorite = favoriteViewModel.isFavorite(meal)
        cell.configure(with: meal,
                       isFavorite: isFavorite)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = favoriteViewModel.meal(at: indexPath.row)
        let userModel = self.favoriteViewModel.user
        let mealDetailViewModel = MealDetailViewModel(mealId: meal.idMeal ?? "",
                                user: userModel)
        let mealDetailViewController = MealDetailViewController(mealDetailViewModel: mealDetailViewModel)
        mealDetailViewController.onFavoriteUpdated = { [weak self] in
            guard let self = self else { return }
            self.favoriteViewModel.loadFavorites {
                DispatchQueue.main.async {
                    self.favoriteCollectionView.reloadItems(at: [indexPath])
                }
            }
        }
        mealDetailViewController.isModalInPresentation = true
        mealDetailViewController.modalPresentationStyle = .fullScreen
        self.present(mealDetailViewController,
                     animated: true)
        
    }
    
}

extension FavoriteViewController: FavoriteCellDelegate {
    func didTapFavorite(on cell: FavoriteCollectionViewCell) {
        guard let indexPath = favoriteCollectionView.indexPath(for: cell) else { return }
        let meal = favoriteViewModel.meal(at: indexPath.item)
        favoriteViewModel.removeMealFromFavorites(meal) { [weak self] in
            self?.favoriteCollectionView.deleteItems(at: [indexPath])
        }
    }
}
