//
//  SearchCollectionViewCell.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 17.05.2025.
//

import UIKit

//MARK: - Protocol
protocol SearchCellDelegate: AnyObject {
    func didTapFavorite(on cell: SearchCollectionViewCell)
}

class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.contentMode = .top
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .white.withAlphaComponent(0.2)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        button.setImage(UIImage(systemName: "heart",
                                withConfiguration: configuration),
                        for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self,
                         action: #selector(favoriteButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: SearchCellDelegate?
    
    //MARK: - Init
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
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(mealImageView)
        stackView.addArrangedSubview(stackView2)
        stackView2.addArrangedSubview(mealNameLabel)
        stackView2.addArrangedSubview(ingredientsLabel)
        contentView.addSubview(favoriteButton)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mealImageView.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
        stackView2.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        mealNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        ingredientsLabel.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(mealImageView).inset(10)
            make.height.width.equalTo(40)
        }
    }
    
    //MARK: - Functions
    func setFavoriteState(isFavorite: Bool){
        let configuration = UIImage.SymbolConfiguration(pointSize: 23)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName,
                                        withConfiguration: configuration),
                                for: .normal)
    }
    
    func animateFavoriteButton() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.3
        animation.duration = 0.1
        animation.autoreverses = true
        animation.repeatCount = 1

        favoriteButton.layer.add(animation, forKey: "bounce")
    }
    
    func configure(with meal: Meal, isFavorite: Bool, ingredients: String) {
        if let url = meal.mealUrl,
           let name = meal.strMeal {
            mealImageView.kf.setImage(with: url)
            mealNameLabel.text = name
            ingredientsLabel.text = ingredients
        }
        setFavoriteState(isFavorite: isFavorite)
    }
    // MARK: - Action
    @objc private func favoriteButtonTapped() {
        delegate?.didTapFavorite(on: self)
        animateFavoriteButton()
    }
}
