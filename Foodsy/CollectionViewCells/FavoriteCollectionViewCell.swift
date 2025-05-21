//
//  FavoriteCollectionViewCell.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 21.05.2025.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Elements
    let favoriteImageView: UIImageView = {
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
    
    let favoriteLabel: UILabel = {
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
        contentView.addSubview(favoriteImageView)
        contentView.addSubview(transparentView)
        transparentView.addSubview(favoriteLabel)
    }
    
    func setupConstraints(){
        favoriteImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        transparentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        favoriteLabel.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
        }
    }
}
