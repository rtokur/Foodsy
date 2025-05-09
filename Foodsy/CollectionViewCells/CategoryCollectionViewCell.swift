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
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 35
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10)
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
        contentView.addSubview(categoryImageView)
        contentView.addSubview(transparentView)
        transparentView.addSubview(categoryLabel)
    }
    
    func setupConstraints(){
        categoryImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        transparentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        categoryLabel.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
        }
    }
}
