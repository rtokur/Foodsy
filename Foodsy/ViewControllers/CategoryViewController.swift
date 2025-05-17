//
//  CategoryViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 13.05.2025.
//

import UIKit

class CategoryViewController: UIViewController {
    //MARK: -Properties
    var categoryViewModel = CategoryViewModel()
    private var categories: [Category] = []
    
    //MARK: - UI Elements
    private let stackView2: UIStackView = {
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
        label.text = "Categories"
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
    
    private let categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0,
                                               left: 20,
                                               bottom: 0,
                                               right: 20)
        return scrollView
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        return stackView
    }()
    
    private let mealCategoryCollectionView: UICollectionView = {
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        categoryViewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.mealCategoryCollectionView.reloadData()
            self.mealCategoryCollectionView.snp.updateConstraints { make in
                make.height.equalTo(self.mealCategoryCollectionView.collectionViewLayout.collectionViewContentSize.height)
            }
            self.addCategoryButtons()
            
        }
        categoryViewModel.fetchMeals()
        categoryViewModel.fetchCategories()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.addSubview(stackView2)
        stackView2.addArrangedSubview(backButton)
        stackView2.addArrangedSubview(categoryLabel)
        stackView2.addArrangedSubview(moreButton)
        view.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        view.addSubview(mealCategoryCollectionView)
        mealCategoryCollectionView.delegate = self
        mealCategoryCollectionView.dataSource = self
        mealCategoryCollectionView.register(MealCategoryBestRecipeCollectionViewCell.self,
                                            forCellWithReuseIdentifier: "MealCategoryCollectionViewCell")
    }
    
    func setupConstraints(){
        stackView2.snp.makeConstraints { make in
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
        categoryScrollView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(stackView2.snp.bottom).offset(20)
        }
        categoryStackView.snp.makeConstraints { make in
            make.height.equalTo(categoryScrollView.frameLayoutGuide)
            make.edges.equalTo(categoryScrollView.contentLayoutGuide)
        }
        mealCategoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(categoryScrollView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    func addCategoryButtons(){
        categoryStackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
        
        var selectedButton: UIButton?
        
        for category in categoryViewModel.categories {
            let button = UIButton()
            let isSelected = (category.strCategory == categoryViewModel.selectedCategory)
            button.applyCategoryStyle(title: category.strCategory ?? "",
                                      isSelected: isSelected)
            button.addTarget(self,
                             action: #selector(categoryButtonTapped),
                             for: .touchUpInside)
            categoryStackView.addArrangedSubview(button)
            
            if isSelected {
                selectedButton = button
            }
        }
        
        if let selectedButton = selectedButton{
            DispatchQueue.main.async {
                self.categoryScrollView.layoutIfNeeded()
                let centerX = selectedButton.center.x
                let scrollWidth = self.categoryScrollView.bounds.width
                var offsetX = centerX - scrollWidth / 2
                
                offsetX = max(0, min(offsetX, self.categoryScrollView.contentSize.width - scrollWidth))
                self.categoryScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
                self.categoryScrollView.scrollRectToVisible(selectedButton.frame, animated: true)
            }
        }
    }
    
    func updateButtonStyles(selectedCategory: String){
        for case let button as UIButton in categoryStackView.arrangedSubviews {
            let isSelected = (button.configuration?.title == selectedCategory)
            
            if var config = button.configuration {
                UIView.animate(withDuration: 0.5) {
                    config.baseBackgroundColor = isSelected ? .darkPink : .white
                    config.baseForegroundColor = isSelected ? .white : .lightGray
                    button.configuration = config
                    button.layer.borderWidth = isSelected ? 0 : 1
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc func backButtonTapped(_ sender: UIButton){
        dismiss(animated: true)
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton){
        guard let selected = sender.configuration?.title else { return }
        categoryViewModel.selectedCategory = selected
        updateButtonStyles(selectedCategory: selected)
        
        DispatchQueue.main.async {
            self.categoryScrollView.layoutIfNeeded()
            let centerX = sender.center.x
            let scrollWidth = self.categoryScrollView.bounds.width
            var offsetX = centerX - scrollWidth / 2
            
            offsetX = max(0, min(offsetX, self.categoryScrollView.contentSize.width - scrollWidth))
            self.categoryScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            self.categoryScrollView.scrollRectToVisible(sender.frame, animated: true)
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categoryViewModel.numberOfMeals
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCategoryCollectionViewCell",
                                                      for: indexPath) as! MealCategoryBestRecipeCollectionViewCell
        if let url = categoryViewModel.meal(at: indexPath.row).mealUrl,
           let name = categoryViewModel.meal(at: indexPath.row).strMeal{
            cell.mealImageView.kf.setImage(with: url)
            cell.mealNameLabel.text = name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = categoryViewModel.meal(at: indexPath.row)
        let mealDetailViewController = MealDetailViewController()
        mealDetailViewController.mealDetailViewModel = MealDetailViewModel(mealId: meal.idMeal ?? "")
        mealDetailViewController.isModalInPresentation = true
        mealDetailViewController.modalPresentationStyle = .fullScreen
        self.present(mealDetailViewController, animated: true)
        
    }
    
}

extension UIButton {
    func applyCategoryStyle(title: String,
                            isSelected: Bool,
                            font: UIFont = .systemFont(ofSize: 14),
                            cornerRadius: CGFloat = 25,
                            animated: Bool = true) {
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(NSAttributedString(string: title,
                                                                     attributes: Constant.attributesCategory))
        config.baseBackgroundColor = isSelected ? .darkPink : .white
        config.baseForegroundColor = isSelected ? .white : .lightGray
        config.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                       leading: 2,
                                                       bottom: 2,
                                                       trailing: 2)
        
        self.configuration = config
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = isSelected ? 0 : 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        self.titleLabel?.font = font
        
    }
}
