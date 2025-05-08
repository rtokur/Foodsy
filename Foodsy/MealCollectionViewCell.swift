//
//  FoodCollectionViewCell.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        contentView.addSubview(mealNameLabel)
    }
    
    func setupConstraints(){
        mealNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
