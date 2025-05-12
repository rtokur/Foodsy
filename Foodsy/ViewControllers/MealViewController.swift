//
//  ViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import UIKit
import SnapKit
import Kingfisher

class MealViewController: UIViewController {
    
    //MARK: - Properties
    private let mealViewModel = MealViewModel()
    
    //MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let stackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Anonymous"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let whatDoYouWantLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to cook today?"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        let textField = searchBar.searchTextField
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search recipe...",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 13)
            ]
        )
        textField.tintColor = .darkGray
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .white
        textField.textColor = .darkGray
        textField.leftView?.tintColor = .lightGray
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.systemFont(ofSize: 13)
        return searchBar
    }()
    
    private let promoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GotoPremiumNow!")
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let stackView4: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("See all",
                        for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 15)
        return button
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70,
                                 height: 70)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collectionView
    }()
    
    private let stackView5: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let bestRecipeLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Recipe"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let seeAllButton2: UIButton = {
        let button = UIButton()
        button.setTitle("See all",
                        for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 15)
        return button
    }()
    
    private let mealCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 230,
                                 height: 280)
        let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
        setupConstraints()
        
        mealViewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.mealCollectionView.reloadData()
            self.categoryCollectionView.reloadData()
        }
        
        mealViewModel.loadMeals()
        mealViewModel.loadCategories()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView1)
        
        stackView1.addArrangedSubview(stackView2)
        
        stackView2.addArrangedSubview(stackView3)
        
        stackView3.addArrangedSubview(userNameLabel)
        
        stackView3.addArrangedSubview(whatDoYouWantLabel)
        
        stackView2.addArrangedSubview(userImageView)
        
        stackView1.addArrangedSubview(searchBar)
        
        stackView1.addArrangedSubview(promoImageView)
        
        stackView1.addArrangedSubview(stackView4)
        
        stackView4.addArrangedSubview(categoryLabel)
        
        stackView4.addArrangedSubview(seeAllButton)
        
        stackView1.addArrangedSubview(categoryCollectionView)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        stackView1.addArrangedSubview(stackView5)
        
        stackView5.addArrangedSubview(bestRecipeLabel)
        
        stackView5.addArrangedSubview(seeAllButton2)
        
        stackView1.addArrangedSubview(mealCollectionView)
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        mealCollectionView.register(MealCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "MealCollectionViewCell")
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        stackView1.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        stackView3.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        userNameLabel.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        whatDoYouWantLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        promoImageView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        stackView4.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        categoryLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        seeAllButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        stackView5.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        bestRecipeLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        seeAllButton2.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        mealCollectionView.snp.makeConstraints { make in
            make.height.equalTo(280)
        }
    }
}

//MARK: - Delegates
extension MealViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealCollectionView {
            return mealViewModel.numberOfMeals()
        }
        return mealViewModel.numberOfCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mealCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell",
                                                          for: indexPath) as! MealCollectionViewCell
            let meal = mealViewModel.meal(at: indexPath.row)
            if let mealUrl = meal.mealUrl,
               let cuisine = meal.strArea{
                cell.mealImageView.kf.setImage(with: mealUrl)
                cell.mealNameLabel.text = meal.strMeal
                cell.cuisineLabel.text = "from \(cuisine)"
                let ingredientsCount = mealViewModel.numberOfIngredients(meal: meal)
                cell.ingredientCountButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(ingredientsCount) ingredients", attributes: Constant.attributesIngredientsCount))
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let category = mealViewModel.category(at: indexPath.row)
        cell.categoryLabel.text = category.strCategory
        if let url = mealViewModel.categories[indexPath.row].categoryUrl{
            cell.categoryImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealCollectionView {
            let meal = mealViewModel.meal(at: indexPath.row)
            let mealDetailViewController = MealDetailViewController()
            mealDetailViewController.mealDetailViewModel = MealDetailViewModel(meal: meal)
            mealDetailViewController.modalPresentationStyle = .fullScreen
            mealDetailViewController.isModalInPresentation = true
            present(mealDetailViewController, animated: true)
        }
    }
}

