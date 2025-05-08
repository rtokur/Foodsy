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
    private let mealCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        return collection
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.addSubview(mealCollectionView)
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        mealCollectionView.register(MealCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "MealCollectionViewCell")
    }
    
    func setupConstraints(){
        mealCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        cell.mealNameLabel.text = meal.strMeal
        return cell
    }
}
