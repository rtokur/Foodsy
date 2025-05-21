//
//  SearchViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 17.05.2025.
//

import UIKit

class SearchViewController: UIViewController {
    var searchViewModel = SearchViewModel()
    
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
                         action: #selector(backButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    let searchBar: UISearchBar = {
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
    
    private let searchCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 350,
                                 height: 150)
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No result."
        label.textColor = .lightGray
        label.isHidden = true
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        
        searchViewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.searchCategoryCollectionView.reloadData()
            self.searchCategoryCollectionView.snp.updateConstraints { make in
                make.height.equalTo(self.searchCategoryCollectionView.collectionViewLayout.collectionViewContentSize.height)
            }
            self.noResultLabel.isHidden = !self.searchViewModel.isResultEmpty()
        }
        searchViewModel.search(with: searchBar.text!)
    }

    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(stackView1)
        stackView1.addArrangedSubview(backButton)
        stackView1.addArrangedSubview(searchBar)
        searchBar.delegate = self
        view.addSubview(searchCategoryCollectionView)
        searchCategoryCollectionView.delegate = self
        searchCategoryCollectionView.dataSource = self
        searchCategoryCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        view.addSubview(noResultLabel)
    }
    
    func setupConstraints(){
        stackView1.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(70)
            make.trailing.equalToSuperview().inset(20)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        searchBar.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        searchCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        noResultLabel.snp.makeConstraints { make in
            make.center.equalTo(searchCategoryCollectionView)
            make.width.height.equalTo(200)
        }
    }
    
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton){
        dismiss(animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UISearchBarDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModel.numberOfMeals()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell",
                                                      for: indexPath) as! SearchCollectionViewCell
        let meal = searchViewModel.searchMeal(at: indexPath.row)
        if let url = meal.mealUrl,
           let name = meal.strMeal {
            cell.mealImageView.kf.setImage(with: url)
            cell.mealNameLabel.text = name
            cell.ingredientsLabel.text = searchViewModel.ingredients(for: indexPath.row).joined(separator: ", ")
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = searchViewModel.searchMeal(at: indexPath.row)
        let mealDetailViewController = MealDetailViewController()
        mealDetailViewController.mealDetailViewModel = MealDetailViewModel(meal: meal)
        mealDetailViewController.modalPresentationStyle = .fullScreen
        mealDetailViewController.isModalInPresentation = true
        present(mealDetailViewController,
                animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchViewModel.search(with: searchText)
        }
    }
}

extension SearchViewController: SearchCellDelegate {
    func didTapFavorite(on cell: SearchCollectionViewCell) {
        guard let indexPath = searchCategoryCollectionView.indexPath(for: cell) else { return }
        let meal = searchViewModel.searchMeal(at: indexPath.item)
        searchViewModel.addMealToFavorites(meal)
    }
}

