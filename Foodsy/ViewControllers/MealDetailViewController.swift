//
//  MealDetailViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 9.05.2025.
//

import UIKit

class MealDetailViewController: UIViewController {
    //MARK: - Properties
    var mealDetailViewModel: MealDetailViewModel!
    
    //MARK: - UI Elements
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.1)
        button.setImage(UIImage(systemName: "chevron.backward"),
                        for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self,
                         action: #selector(backButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private let detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        return stackView
    }()
    
    private let cuisineButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: Constant.lightPink)
        button.layer.cornerRadius = 17
        button.tintColor = .black
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        let configurationImage = UIImage.SymbolConfiguration(pointSize: 13)
        button.setImage(UIImage(systemName: "frying.pan",
                                withConfiguration: configurationImage),
                        for: .normal)
        button.configuration = configuration
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "heart",
                                withConfiguration: configuration),
                        for: .normal)
        button.tintColor = .systemPink
        return button
    }()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let mealDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 18
        return stackView
    }()
    
    private let ingredientsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: Constant.pink)
        var configurationImage = UIImage.SymbolConfiguration(pointSize: 10)
        button.setImage(UIImage(systemName: "list.bullet",
                                withConfiguration: configurationImage),
                        for: .normal)
        button.layer.cornerRadius = 18
        button.tintColor = .white
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 5
        configuration.attributedTitle = AttributedString(NSAttributedString(string: "Ingredients",
                                                                            attributes: Constant.attributesIngredients))
        button.configuration = configuration
        return button
    }()
    
    private let instructionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        var configurationImage = UIImage.SymbolConfiguration(pointSize: 10)
        button.setImage(UIImage(systemName: "document",
                                withConfiguration: configurationImage),
                        for: .normal)
        button.layer.cornerRadius = 18
        button.tintColor = .lightGray
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 5
        configuration.attributedTitle = AttributedString(NSAttributedString(string: "Instruction",
                                                                            attributes: Constant.attributesInstruction))
        button.configuration = configuration
        return button
    }()
    
    private let textView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        mealDetailViewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(mealImageView)
        view.addSubview(gradientView)
        setupGradient()
        view.addSubview(backButton)
        view.addSubview(detailView)
        detailView.addSubview(scrollView)
        scrollView.addSubview(stackView1)
        detailView.addSubview(cuisineButton)
        detailView.addSubview(favoriteButton)
        stackView1.addArrangedSubview(mealNameLabel)
        stackView1.addArrangedSubview(lineView)
        stackView1.addArrangedSubview(mealDetailView)
        mealDetailView.addSubview(stackView2)
        stackView2.addArrangedSubview(ingredientsButton)
        stackView2.addArrangedSubview(instructionButton)
        stackView1.addArrangedSubview(textView)
        textView.addSubview(textLabel)
    }
    
    func setupConstraints(){
        mealImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalTo(mealImageView)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(40)
        }
        detailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(mealImageView.snp.bottom).inset(26)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(detailView).inset(30)
            make.top.equalToSuperview().inset(80)
            make.bottom.equalToSuperview()
        }
        stackView1.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        cuisineButton.snp.makeConstraints { make in
            make.leading.equalTo(stackView1)
            make.top.equalToSuperview().inset(30)
            make.height.equalTo(35)
            make.width.equalTo(130)
        }
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(stackView1)
            make.top.equalToSuperview().inset(30)
            make.height.width.equalTo(45)
        }
        mealNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        mealDetailView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        stackView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.top.bottom.equalToSuperview().inset(7)
        }
        ingredientsButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        instructionButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    //MARK: - Functions
    func setupGradient(){
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.8).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5,
                                           y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5,
                                         y: 0.0)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func updateUI(){
        guard let _ = mealDetailViewModel.meal else { return }
        
        if let url = mealDetailViewModel.imageURL {
            mealImageView.kf.setImage(with: url)
        }
        mealNameLabel.text = mealDetailViewModel.mealName
        textLabel.text = mealDetailViewModel.ingredients.joined(separator: "\n")
        cuisineButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "\(mealDetailViewModel.area)",
                                                                            attributes: Constant.attributesMinutes))
    }
    
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton){
        dismiss(animated: true)
    }

    @objc func buttonTapped(_ sender: UIButton){
        if sender == ingredientsButton {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.ingredientsButton.backgroundColor = UIColor(named: Constant.pink)
                self?.ingredientsButton.tintColor = .white
                self?.ingredientsButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "Ingredients",
                                                                                                             attributes: Constant.attributesIngredients))
                self?.textLabel.text = self?.mealDetailViewModel.ingredients.joined(separator: "\n")
                self?.instructionButton.backgroundColor = .white
                self?.instructionButton.tintColor = .lightGray
                self?.instructionButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "Instruction",
                                                                                                             attributes: Constant.attributesInstruction))
            }
        }else{
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.instructionButton.backgroundColor = UIColor(named: Constant.pink)
                self?.instructionButton.tintColor = .white
                self?.instructionButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "Instruction",
                                                                                                             attributes: Constant.attributesIngredients))
                self?.textLabel.text = self?.mealDetailViewModel.instructions.joined(separator: "\n")
                self?.ingredientsButton.backgroundColor = .white
                self?.ingredientsButton.tintColor = .lightGray
                self?.ingredientsButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "Ingredients",
                                                                                                             attributes: Constant.attributesInstruction))
            }
        }
    }
}

public enum Constant {
    static let lightPink = "LightPink"
    static let pink = "DarkPink"
    static let attributesMinutes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12),
                                                                   .foregroundColor: UIColor.black]
    static let attributesIngredientsCount: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10),
                                                                            .foregroundColor: UIColor.white]
    static let attributesIngredients: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13),
                                                                       .foregroundColor: UIColor.white]
    static let attributesInstruction: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13),
                                                                       .foregroundColor: UIColor.lightGray]
    static let attributesCategory: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 11)]
}
