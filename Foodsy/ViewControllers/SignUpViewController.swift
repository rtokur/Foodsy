//
//  SignUpViewController.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 19.05.2025.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {
    //MARK: - Properties
    private let signUpViewModel = SignUpViewModel()
    
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
    
    private let signUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
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
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Register to create a account"
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = SkyFloatingLabelTextField()
        textField.title = "name"
        textField.textColor = .black
        textField.titleColor = UIColor(named: Constant.lightPink2)!
        textField.selectedTitleColor = UIColor(named: Constant.pink)!
        textField.selectedLineColor = .lightGray
        textField.placeholder = "name"
        textField.textContentType = .name
        return textField
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
                         action: #selector(toggleEyeButtonAction),
                         for: .touchUpInside)
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 30,
                              height: 30)
        return button
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = SkyFloatingLabelTextField()
        textField.title = "confirm password"
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
    
    private let toggleConfirmPasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"),
                        for: .normal)
        button.tintColor = .gray
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 30,
                              height: 30)
        button.addTarget(self,
                         action: #selector(toggleEyeButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = UIColor(named: Constant.pink)
        button.layer.cornerRadius = 30
        button.addTarget(self,
                         action: #selector(signUpButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private let stackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private let doHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Do have an account?"
        label.textColor = .black
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in",
                        for: .normal)
        button.setTitleColor(UIColor(named: Constant.pink),
                             for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.cornerRadius = 15
        button.addTarget(self,
                         action: #selector(signInButtonAction),
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
        view.backgroundColor = .white
        view.backgroundColor = UIColor(named: Constant.lightGray)
        view.addSubview(colorView)
        view.addSubview(reflectionView)
        view.addSubview(signUpView)
        signUpView.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(registerLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.rightView = toggleEyeButton
        passwordTextField.rightViewMode = .always
        stackView.addArrangedSubview(confirmPasswordTextField)
        confirmPasswordTextField.rightView = toggleConfirmPasswordButton
        confirmPasswordTextField.rightViewMode = .always
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(stackView3)
        stackView3.addArrangedSubview(doHaveAccountLabel)
        stackView3.addArrangedSubview(signInButton)
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
        signUpView.snp.makeConstraints { make in
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
        signUpLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        registerLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        signUpButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        stackView3.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        doHaveAccountLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }
    
    //MARK: - Actions
    @objc func toggleEyeButtonAction(_ sender: UIButton) {
        if sender.superview == passwordTextField {
            passwordTextField.isSecureTextEntry.toggle()
            
            let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            toggleEyeButton.setImage(UIImage(systemName: imageName),
                                     for: .normal)
        }else if sender.superview == confirmPasswordTextField {
            confirmPasswordTextField.isSecureTextEntry.toggle()
            
            let imageName = confirmPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            toggleConfirmPasswordButton.setImage(UIImage(systemName: imageName),
                                                 for: .normal)
        }
    }
    
    @objc func signUpButtonAction(_ sender: UIButton){
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              password == confirmPasswordTextField.text,
              let name = nameTextField.text else {
            showAlert(message: "Please fill in all fields correctly.")
            return
        }
        
        signUpViewModel.register(name: name,
                                 email: email,
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
                    self?.showAlert(message: failure.localizedDescription)
                }
            }
        }
    }
    
    @objc func signInButtonAction(_ sender: UIButton){
        dismiss(animated: true)
    }
}
