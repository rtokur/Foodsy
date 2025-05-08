//
//  CategoryCollectionViewCell.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 8.05.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Elements
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        contentView.addSubview(categoryImageView)
    }
    
    func setupConstraints(){
        categoryImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
