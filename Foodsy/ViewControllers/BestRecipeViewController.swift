//
//  BestRecipeViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 17.05.2025.
//

import UIKit

class BestRecipeViewController: UIViewController {
    //MARK: - Properties
    var bestRecipeViewModel: MealViewModel
    
    init(bestRecipeViewModel: MealViewModel) {
        self.bestRecipeViewModel = bestRecipeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements
    private let stackView1: UIStackView = {
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
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Recipe"
        label.font = .boldSystemFont(ofSize: 23)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let bestRecipeCategoryCollectionView: UICollectionView = {
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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bestRecipeCategoryCollectionView.snp.updateConstraints { make in
            make.height.equalTo(self.bestRecipeCategoryCollectionView.collectionViewLayout.collectionViewContentSize.height)
        }
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(stackView1)
        stackView1.addArrangedSubview(backButton)
        stackView1.addArrangedSubview(categoryLabel)
        view.addSubview(bestRecipeCategoryCollectionView)
        bestRecipeCategoryCollectionView.delegate = self
        bestRecipeCategoryCollectionView.dataSource = self
        bestRecipeCategoryCollectionView.register(MealCategoryBestRecipeCollectionViewCell.self,
                                            forCellWithReuseIdentifier: "MealCategoryBestRecipeCollectionViewCell")
    }
    
    func setupConstraints(){
        stackView1.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        categoryLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        bestRecipeCategoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(stackView1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    //MARK: - Actions
    @objc func backButtonTapped(_ sender: UIButton){
        dismiss(animated: true)
    }

}

extension BestRecipeViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestRecipeViewModel.numberOfMeals()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCategoryBestRecipeCollectionViewCell", for: indexPath) as! MealCategoryBestRecipeCollectionViewCell
        let meal = bestRecipeViewModel.meal(at: indexPath.row)
        let isFavorite = bestRecipeViewModel.isFavorite(meal)
        cell.configure(with: meal,
                       isFavorite: isFavorite)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = bestRecipeViewModel.meal(at: indexPath.row)
        let userModel = bestRecipeViewModel.user
        let mealDetailViewModel = MealDetailViewModel(meal: meal, user: userModel)
        let mealDetailViewController = MealDetailViewController(mealDetailViewModel: mealDetailViewModel)
        mealDetailViewController.onFavoriteUpdated = { [weak self] in
            guard let self = self else { return }
            self.bestRecipeViewModel.loadFavorites {

                DispatchQueue.main.async {
                    self.bestRecipeCategoryCollectionView.reloadItems(at: [indexPath])
                }
            }
        }
        mealDetailViewController.modalPresentationStyle = .fullScreen
        mealDetailViewController.isModalInPresentation = true
        present(mealDetailViewController,
                animated: true)
    }
    
}

extension BestRecipeViewController: MealCategoryBestRecipeCellDelegate {
    func didTapFavorite(on cell: MealCategoryBestRecipeCollectionViewCell) {
        guard let indexPath = bestRecipeCategoryCollectionView.indexPath(for: cell) else { return }
        let meal = bestRecipeViewModel.meal(at: indexPath.item)
        bestRecipeViewModel.toggleFavorite(for: meal) { [weak self] in
            guard let self = self else { return }
            let updatedIsFavorite = self.bestRecipeViewModel.isFavorite(meal)
            cell.setFavoriteState(isFavorite: updatedIsFavorite)
        }
    }
}
