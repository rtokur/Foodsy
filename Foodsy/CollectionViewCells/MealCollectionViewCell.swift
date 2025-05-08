//
//  FoodCollectionViewCell.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Elements
    let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
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
        contentView.addSubview(mealImageView)
    }
    
    func setupConstraints(){
        mealImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
