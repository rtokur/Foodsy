//
//  LoginViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 18.05.2025.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn

class LoginViewController: UIViewController {
    //MARK: - Properties
    private let loginViewModel = LoginViewModel()
    
    //MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: Constant.lightGray)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(named: Constant.lightPink2)
        return view
    }()
    
    private let reflectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let loginView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        return stackView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .brown
        imageView.image = UIImage(named: "icon")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in to access your account"
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = SkyFloatingLabelTextField()
        textField.title = "email"
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.titleColor = UIColor(named: Constant.lightPink2)!
        textField.selectedTitleColor = UIColor(named: Constant.pink)!
        textField.selectedLineColor = .lightGray
        textField.placeholder = "example@gmail.com"
        textField.textContentType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = SkyFloatingLabelTextField()
        textField.title = "password"
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.titleColor = UIColor(named: Constant.lightPink2)!
        textField.selectedTitleColor = UIColor(named: Constant.pink)!
        textField.selectedLineColor = .lightGray
        textField.placeholder = "*********"
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        return textField
    }()
    
    private let toggleEyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"),
                        for: .normal)
        button.tintColor = .gray
        button.addTarget(self,
                         action: #selector(toogleEyeButtonAction),
                         for: .touchUpInside)
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 30,
                              height: 30)
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = UIColor(named: Constant.pink)
        button.layer.cornerRadius = 26
        button.addTarget(self,
                         action: #selector(signInButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private let orLoginWithLabel: UILabel = {
        let label = UILabel()
        label.text = "or login with"
        label.textColor = .black
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    private let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let googleButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(NSAttributedString(string: "Google",
                                                                            attributes: Constant.attributesGoogleButton))
        configuration.image = UIImage(named: "google")
        configuration.imagePadding = 10
        button.configuration = configuration
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.addTarget(self,
                         action: #selector(SignInWithGoogle),
                         for: .touchUpInside)
        return button
    }()
    
    private let gitHubButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(NSAttributedString(string: "GitHub",
                                                                            attributes: Constant.attributesGoogleButton))
        configuration.image = UIImage(named: "github")
        configuration.imagePadding = 10
        button.configuration = configuration
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.addTarget(self,
                         action: #selector(SignInWithGitHub),
                         for: .touchUpInside)
        return button
    }()
    
    private let stackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private let dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = .black
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor(named: Constant.pink),
                             for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.cornerRadius = 25
        button.addTarget(self,
                         action: #selector(signUpButtonAction),
                         for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(colorView)
        scrollView.addSubview(reflectionView)
        scrollView.addSubview(loginView)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        loginView.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.rightView = toggleEyeButton
        passwordTextField.rightViewMode = .always
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(orLoginWithLabel)
        stackView.addArrangedSubview(stackView2)
        stackView2.addArrangedSubview(googleButton)
        stackView2.addArrangedSubview(gitHubButton)
        stackView.addArrangedSubview(stackView3)
        stackView3.addArrangedSubview(dontHaveAccountLabel)
        stackView3.addArrangedSubview(signUpButton)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        colorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(420)
        }
        reflectionView.snp.makeConstraints { make in
            make.bottom.equalTo(loginView.snp.top).inset(25)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        loginView.snp.makeConstraints { make in
            make.height.equalTo(600)
            make.leading.trailing.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        signInLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        loginLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        orLoginWithLabel.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        stackView2.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        googleButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        gitHubButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        stackView3.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        dontHaveAccountLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        signUpButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }
    
    //MARK: - Actions
    @objc func signInButtonAction(_ sender: UIButton){
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            showAlert(message: "Please fill all fields.")
            return
        }
        
        loginViewModel.login(email: email,
                             password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userModel):
                    let mealViewModel = MealViewModel(user: userModel)
                    let mealViewController = MealViewController(mealViewModel: mealViewModel)
                    mealViewController.modalPresentationStyle = .fullScreen
                    mealViewController.isModalInPresentation = true
                    self?.present(mealViewController,
                                  animated: true)
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self?.showAlert(message: "Please fill the areas correctly.")
                }
            }
        }
    }
    
    @objc func signUpButtonAction(_ sender: UIButton){
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .fullScreen
        signUpViewController.isModalInPresentation = true
        present(signUpViewController, animated: true)
    }
    
    @objc func toogleEyeButtonAction(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        toggleEyeButton.setImage(UIImage(systemName: imageName),
                                 for: .normal)
    }
    
    @objc func SignInWithGoogle(_ sender: UIButton){
        loginViewModel.loginWithGoogle(presenting: self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userModel):
                    let mealViewModel = MealViewModel(user: userModel)
                    let mealViewController = MealViewController(mealViewModel: mealViewModel)
                    mealViewController.modalPresentationStyle = .fullScreen
                    mealViewController.isModalInPresentation = true
                    self?.present(mealViewController,
                                  animated: true)
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self?.showAlert(message: "Please fill the areas.")
                }
            }
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func SignInWithGitHub(_ sender: UIButton){
        loginViewModel.loginWithGitHub { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userModel):
                    let mealViewModel = MealViewModel(user: userModel)
                    let mealViewController = MealViewController(mealViewModel: mealViewModel)
                    mealViewController.modalPresentationStyle = .fullScreen
                    mealViewController.isModalInPresentation = true
                    self?.present(mealViewController,
                                  animated: true)
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self?.showAlert(message: "Please fill the areas.")
                }
            }
        }
    }
}

