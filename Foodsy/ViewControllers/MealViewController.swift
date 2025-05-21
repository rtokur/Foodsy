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
    var mealViewModel: MealViewModel
    
    init(mealViewModel: MealViewModel) {
        self.mealViewModel = mealViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements
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
    
    private let userNameButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.compact.down")
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.imagePlacement = .trailing
        button.tintColor = .black
        button.configuration = configuration
        button.contentHorizontalAlignment = .left
        return button
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
        imageView.image = UIImage(named: "user")!.withTintColor(UIColor(named: Constant.pink)!)
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
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
        button.setTitleColor(.systemPink,
                             for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir",
                                         size: 15)
        button.addTarget(self,
                         action: #selector(goToCategory),
                         for: .touchUpInside)
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
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 20,
                                                   bottom: 0,
                                                   right: 20)
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
        button.setTitleColor(.systemPink,
                             for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir",
                                         size: 15)
        button.addTarget(self,
                         action: #selector(goToBestRecipe),
                         for: .touchUpInside)
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
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 20,
                                                   bottom: 0,
                                                   right: 20)
        return collectionView
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupConstraints()
        
        mealViewModel.loadFavorites { [weak self] in
            self?.mealViewModel.loadMeals()
        }
        mealViewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.mealCollectionView.reloadData()
            self.categoryCollectionView.reloadData()
            self.userNameButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: mealViewModel.userName,
                                                                                                    attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                                                                                                                 .foregroundColor: UIColor.black]))
        }
        mealViewModel.loadCategories()
        configureMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.text = ""
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(stackView2)
        
        stackView2.addArrangedSubview(stackView3)
        
        stackView3.addArrangedSubview(userNameButton)
        
        stackView3.addArrangedSubview(whatDoYouWantLabel)
        
        stackView2.addArrangedSubview(userImageView)
        
        view.addSubview(stackView1)
        
        searchBar.delegate = self
        stackView1.addArrangedSubview(searchBar)
        
        stackView1.addArrangedSubview(promoImageView)
        
        stackView1.addArrangedSubview(stackView4)
        
        stackView4.addArrangedSubview(categoryLabel)
        
        stackView4.addArrangedSubview(seeAllButton)
        
        view.addSubview(categoryCollectionView)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        view.addSubview(stackView5)
        
        stackView5.addArrangedSubview(bestRecipeLabel)
        
        stackView5.addArrangedSubview(seeAllButton2)
        
        view.addSubview(mealCollectionView)
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        mealCollectionView.register(MealCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "MealCollectionViewCell")
    }
    
    func setupConstraints(){
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        stackView3.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        userNameButton.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        whatDoYouWantLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        stackView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        promoImageView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
        stackView4.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        categoryLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        seeAllButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.top.equalTo(stackView4.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        stackView5.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(15)
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
            make.top.equalTo(stackView5.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Functions
    func configureMenu(){
        let actionClosure = { [weak self] (action: UIAction) in
            let userModel = self?.mealViewModel.user
            let favoriteViewModel = FavoriteViewModel(user: userModel!)
            let favoriteViewController = FavoriteViewController(favoriteViewModel: favoriteViewModel)
            favoriteViewController.isModalInPresentation = true
            favoriteViewController.modalPresentationStyle = .fullScreen
            self?.present(favoriteViewController, animated: true)
        }
        var menuChildren : [UIMenuElement] = []
        menuChildren.append(UIAction(title: "Favorites", handler: actionClosure))
        userNameButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        userNameButton.showsMenuAsPrimaryAction = true
    }
    
    //MARK: - Actions
    @objc func goToCategory(_ sender: UIButton){
        let userModel = self.mealViewModel.user
        let categoryViewModel = CategoryViewModel(user: userModel)
        let categoryViewController = CategoryViewController(categoryViewModel: categoryViewModel)
        categoryViewController.categoryViewModel.selectedCategory = "Beef"
        categoryViewController.modalPresentationStyle = .fullScreen
        categoryViewController.isModalInPresentation = true
        present(categoryViewController, animated: true)
    }
    
    @objc func goToBestRecipe(_ sender: UIButton){
        let bestRecipeViewController = BestRecipeViewController()
        bestRecipeViewController.bestRecipeViewModel = mealViewModel
        bestRecipeViewController.modalPresentationStyle = .fullScreen
        bestRecipeViewController.isModalInPresentation = true
        present(bestRecipeViewController, animated: true)
    }
}

//MARK: - Delegates
extension MealViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UISearchBarDelegate{
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
               let cuisine = meal.strArea,
               let category = meal.strCategory{
                cell.mealImageView.kf.setImage(with: mealUrl)
                cell.mealNameLabel.text = meal.strMeal
                cell.categoryLabel.text = "\(category)"
                let ingredientsCount = mealViewModel.numberOfIngredients(meal: meal)
                cell.ingredientCountButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(ingredientsCount) ingredients",
                                                                                                                attributes: Constant.attributesIngredientsCount))
                cell.cuisineButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(cuisine)",
                                                                                                        attributes: Constant.attributesIngredientsCount))
            }
            cell.setFavoriteState(isFavorite: mealViewModel.isFavorite(meal))
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell",
                                                      for: indexPath) as! CategoryCollectionViewCell
        let category = mealViewModel.category(at: indexPath.row)
        cell.categoryLabel.text = category.strCategory
        if let url = mealViewModel.categories[indexPath.row].categoryUrl{
            cell.categoryImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealCollectionView {
            let meal = mealViewModel.meal(at: indexPath.row)
            let mealDetailViewController = MealDetailViewController()
            mealDetailViewController.mealDetailViewModel = MealDetailViewModel(meal: meal)
            mealDetailViewController.modalPresentationStyle = .fullScreen
            mealDetailViewController.isModalInPresentation = true
            present(mealDetailViewController,
                    animated: true)
        }else{
            let category = mealViewModel.category(at: indexPath.row).strCategory ?? ""
            let userModel = self.mealViewModel.user
            let categoryViewModel = CategoryViewModel(user: userModel)
            let categoryViewController = CategoryViewController(categoryViewModel: categoryViewModel)
            categoryViewController.categoryViewModel.selectedCategory = category
            categoryViewController.modalPresentationStyle = .fullScreen
            categoryViewController.isModalInPresentation = true
            present(categoryViewController, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let searchViewController = SearchViewController()
            searchViewController.searchBar.text = searchText
            searchViewController.isModalInPresentation = true
            searchViewController.modalPresentationStyle = .fullScreen
            present(searchViewController, animated: true)
        }
    }
}

extension MealViewController: MealCellDelegate {
    func didTapFavorite(on cell: MealCollectionViewCell) {
        guard let indexPath = mealCollectionView.indexPath(for: cell) else { return }
        let meal = mealViewModel.meal(at: indexPath.item)
        mealViewModel.toggleFavoriteState(for: meal) { [weak self] in
            guard let self = self else { return }
            let updatedIsFavorite = self.mealViewModel.isFavorite(meal)
            cell.setFavoriteState(isFavorite: updatedIsFavorite)
        }
    }
}
