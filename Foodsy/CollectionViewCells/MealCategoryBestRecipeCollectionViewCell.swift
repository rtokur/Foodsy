//
//  MealCategoryCollectionViewCell.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 13.05.2025.
//

import UIKit
import AVFoundation

//MARK: - Protocol
protocol MealCategoryBestRecipeCellDelegate: AnyObject {
    func didTapFavorite(on cell: MealCategoryBestRecipeCollectionViewCell)
}

class MealCategoryBestRecipeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
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
    
    //MARK: - Properties
    weak var delegate: MealCategoryBestRecipeCellDelegate?
    var audioPlayer: AVAudioPlayer?
    
    //MARK: - Init
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
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.addSubview(mealImageView)
        contentView.addSubview(gradientView)
        setupGradient()
        contentView.addSubview(mealNameLabel)
        contentView.addSubview(favoriteButton)
    }
    
    func setupConstraints(){
        mealImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mealNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(17)
        }
        favoriteButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(15)
            make.height.width.equalTo(40)
        }
    }
    
    //MARK: - Functions
    func setupGradient(){
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.9).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5,
                                           y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5,
                                         y: 0.0)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func setFavoriteState(isFavorite: Bool){
        let configuration = UIImage.SymbolConfiguration(pointSize: 23)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName,
                                        withConfiguration: configuration),
                                for: .normal)
    }
    
    func animateFavoriteButton() {
        playSound()
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.3
        animation.duration = 0.15
        animation.autoreverses = true
        animation.repeatCount = 1

        favoriteButton.layer.add(animation, forKey: "bounce")
    }
    
    func playSound(){
        guard let soundURL = Bundle.main.url(forResource: "tapSound", withExtension: "mp3") else {
            print("Ses dosyası bulunamadı.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Ses çalınamadı: \(error.localizedDescription)")
        }
    }
    
    func configure(with meal: Meal, isFavorite: Bool) {
        if let url = meal.mealUrl,
           let name = meal.strMeal{
            mealImageView.kf.setImage(with: url)
            mealNameLabel.text = name
        }
        setFavoriteState(isFavorite: isFavorite)
    }
    
    //MARK: - Actions
    @objc private func favoriteButtonTapped() {
        delegate?.didTapFavorite(on: self)
        animateFavoriteButton()
    }
}
