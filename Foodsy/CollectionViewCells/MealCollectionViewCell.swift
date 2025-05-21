//
//  FoodCollectionViewCell.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 7.05.2025.
//

import UIKit
protocol MealCellDelegate: AnyObject {
    func didTapFavorite(on cell: MealCollectionViewCell)
}
class MealCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Elements
    let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray.withAlphaComponent(0.2)
        let configuration = UIImage.SymbolConfiguration(pointSize: 23)
        button.setImage(UIImage(systemName: "heart", withConfiguration: configuration),
                        for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self,
                         action: #selector(favoriteButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        return lineView
    }()
    
    private let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let cuisineButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "meal"),
                        for: .normal)
        button.contentHorizontalAlignment = .left
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 5
        button.configuration = configuration
        return button
    }()
    
    let ingredientCountButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recipe"),
                        for: .normal)
        button.contentHorizontalAlignment = .left
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 5
        button.configuration = configuration
        return button
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    // MARK: - Delegate
    weak var delegate: MealCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        contentView.addSubview(mealImageView)
        
        contentView.addSubview(favoriteButton)
        
        contentView.addSubview(gradientView)
        setupGradient()
        
        gradientView.addSubview(stackView)
        
        stackView.addArrangedSubview(mealNameLabel)
        
        stackView.addArrangedSubview(categoryLabel)
        
        stackView.addArrangedSubview(lineView)
        
        stackView.addArrangedSubview(stackView2)
        
        stackView2.addArrangedSubview(cuisineButton)
        
        stackView2.addArrangedSubview(ingredientCountButton)
    }
    
    func setupConstraints(){
        mealImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.top.equalTo(15)
        }
        gradientView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        stackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        mealNameLabel.snp.makeConstraints { make in
            make.height.equalTo(23)
        }
        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        stackView2.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        cuisineButton.snp.makeConstraints { make in
            make.width.equalTo(95)
        }
        ingredientCountButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    
    func setupGradient(){
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.9).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5,
                                           y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5,
                                         y: 0.0)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Action
    @objc private func favoriteButtonTapped() {
        delegate?.didTapFavorite(on: self)
    }
}
