//
//  ViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import UIKit
import SnapKit

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
        stackView.spacing = 15
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
        return label
    }()
    
    private let whatDoYouWantLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to cook today?"
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search recipe..."
        return searchBar
    }()
    
    private let promoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .purple
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
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("See all",
                        for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100,
                                 height: 100)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
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
        return label
    }()
    
    private let seeAllButton2: UIButton = {
        let button = UIButton()
        button.setTitle("See all",
                        for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    private let mealCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250,
                                 height: 300)
        let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
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
        }
        
        mealViewModel.loadMeals()
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
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        stackView1.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(70)
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
            make.width.height.equalTo(70)
        }
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        promoImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
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
            make.height.equalTo(100)
        }
        stackView5.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        bestRecipeLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        seeAllButton2.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        mealCollectionView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
    }
}

//MARK: - Delegates
extension MealViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return mealViewModel.numberOfMeals()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell",
                                                      for: indexPath) as! MealCollectionViewCell
        let meal = mealViewModel.meal(at: indexPath.row)
        print(meal.strMealThumb)
        return cell
    }
}
