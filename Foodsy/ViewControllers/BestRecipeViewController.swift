//
//  BestRecipeViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 17.05.2025.
//

import UIKit

class BestRecipeViewController: UIViewController {
    //MARK: - Properties
    var bestRecipeViewModel: MealViewModel!
    
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
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .black
        button.setImage(UIImage(systemName: "ellipsis"),
                        for: .normal)
        return button
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
        view.backgroundColor = .white
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
        view.addSubview(stackView1)
        stackView1.addArrangedSubview(backButton)
        stackView1.addArrangedSubview(categoryLabel)
        stackView1.addArrangedSubview(moreButton)
        view.addSubview(bestRecipeCategoryCollectionView)
        bestRecipeCategoryCollectionView.delegate = self
        bestRecipeCategoryCollectionView.dataSource = self
        bestRecipeCategoryCollectionView.register(MealCategoryBestRecipeCollectionViewCell.self,
                                            forCellWithReuseIdentifier: "MealCategoryBestRecipeCollectionViewCell")
    }
    
    func setupConstraints(){
        stackView1.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        categoryLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        moreButton.snp.makeConstraints { make in
            make.width.equalTo(50)
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
        if let url = bestRecipeViewModel.meals[indexPath.row].mealUrl,
           let name = bestRecipeViewModel.meals[indexPath.row].strMeal{
            cell.mealImageView.kf.setImage(with: url)
            cell.mealNameLabel.text = name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = bestRecipeViewModel.meal(at: indexPath.row)
        let mealDetailViewController = MealDetailViewController()
        mealDetailViewController.mealDetailViewModel = MealDetailViewModel(meal: meal)
        mealDetailViewController.modalPresentationStyle = .fullScreen
        mealDetailViewController.isModalInPresentation = true
        present(mealDetailViewController,
                animated: true)
    }
    
}
