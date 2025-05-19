//
//  LoginViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 18.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    //MARK: - UI Elements
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
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "example@gmail.com",
                                                             attributes: Constant.attributesPlaceholder)
        textField.textColor = .black
        textField.layer.cornerRadius = 15
        textField.tintColor = .black
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        textField.layer.borderWidth = 1
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "*********",
                                                             attributes: Constant.attributesPlaceholder)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 15
        textField.font = .systemFont(ofSize: 15)
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        return textField
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
        return button
    }()
    
    private let appleButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(NSAttributedString(string: "Apple",
                                                                            attributes: Constant.attributesGoogleButton))
        configuration.image = UIImage(systemName: "clock")
        configuration.imagePadding = 10
        button.configuration = configuration
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
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
        button.setTitleColor(UIColor(named: Constant.pink), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.cornerRadius = 15
        button.addTarget(self,
                         action: #selector(signUpButtonAction),
                         for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Constant.lightGray)
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.addSubview(colorView)
        view.addSubview(reflectionView)
        view.addSubview(loginView)
        loginView.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(emailTextField)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .always
        stackView.addArrangedSubview(passwordTextField)
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: passwordTextField.frame.height))
        passwordTextField.leftView = paddingView2
        passwordTextField.leftViewMode = .always
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(orLoginWithLabel)
        stackView.addArrangedSubview(stackView2)
        stackView2.addArrangedSubview(googleButton)
        stackView2.addArrangedSubview(appleButton)
        stackView.addArrangedSubview(stackView3)
        stackView3.addArrangedSubview(dontHaveAccountLabel)
        stackView3.addArrangedSubview(signUpButton)
    }
    
    func setupConstraints(){
        colorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(420)
        }
        reflectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(105)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        loginView.snp.makeConstraints { make in
            make.height.equalTo(600)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(90)
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
        appleButton.snp.makeConstraints { make in
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
            let alert = UIAlertController(title: "Error",
                                          message: "Please fill the areas.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        Auth.auth().signIn(withEmail: email,
                           password: password) { [weak self] result, error in
            if let error = error {
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: .cancel))
                self?.present(alert, animated: true)
                return
            }
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                let email = user.email
                
                let db = Firestore.firestore()
                db.collection("users").document(uid).getDocument { snapshot, error in
                    if let error = error {
                        print("Not taken user from Firebase: \(error)")
                        return
                    }
                    guard let data = snapshot?.data(),
                          let username = data["username"] as? String else {
                        print("No username info.")
                        return
                    }
                    
                    let userModel = UserModel(uid: user.uid,
                                              email: user.email,
                                              name: username)
                    let mealViewModel = MealViewModel(user: userModel)
                    let mealViewController = MealViewController(mealViewModel: mealViewModel)
                    mealViewController.modalPresentationStyle = .fullScreen
                    mealViewController.isModalInPresentation = true
                    self?.present(mealViewController, animated: true)
                }
            }
        }
    }
    
    @objc func signUpButtonAction(_ sender: UIButton){
        let signUpViewController = SignUpViewController()
        signUpViewController.isModalInPresentation = true
        signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true)
    }
}
