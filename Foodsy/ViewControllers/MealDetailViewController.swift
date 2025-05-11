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
        button.backgroundColor = .white.withAlphaComponent(0.5)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
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
    
    private let minuteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: Constant.lightPink)
        button.layer.cornerRadius = 17
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitle("40 mins", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "clock"), for: .normal)
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "heart", withConfiguration: configuration), for: .normal)
        button.tintColor = .systemPink
        return button
    }()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
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
        button.setTitle("Ingredients", for: .normal)
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let instructionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Instruction", for: .normal)
        button.setImage(UIImage(systemName: "document"), for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.tintColor = .lightGray
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
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
        if let url = mealDetailViewModel.imageURL {
            mealImageView.kf.setImage(with: url)
        }
        view.addSubview(gradientView)
        setupGradient()
        view.addSubview(backButton)
        view.addSubview(detailView)
        detailView.addSubview(scrollView)
        scrollView.addSubview(stackView1)
        detailView.addSubview(minuteButton)
        detailView.addSubview(favoriteButton)
        stackView1.addArrangedSubview(mealNameLabel)
        mealNameLabel.text = mealDetailViewModel.mealName
        stackView1.addArrangedSubview(lineView)
        stackView1.addArrangedSubview(mealDetailView)
        mealDetailView.addSubview(stackView2)
        stackView2.addArrangedSubview(ingredientsButton)
        stackView2.addArrangedSubview(instructionButton)
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
            make.top.equalTo(mealImageView.snp.bottom)
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
        minuteButton.snp.makeConstraints { make in
            make.leading.equalTo(stackView1)
            make.top.equalToSuperview().inset(30)
            make.height.equalTo(35)
            make.width.equalTo(120)
        }
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(stackView1)
            make.top.equalToSuperview().inset(30)
            make.height.width.equalTo(45)
        }
        mealNameLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
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
    }
    
    //MARK: - Functions
    func setupGradient(){
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.8).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton){
        dismiss(animated: true)
    }

}

public enum Constant {
    static let lightPink = "LightPink"
    static let pink = "Pink"
}
