//
//  LoginVC.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 20/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    private var vm: LoginVMType!
    private let chatImage: UIImage? = UIImage(named: "chat_icon")
    private let addImage: UIImage? = UIImage(named: "add_icon")
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    // MARK: - Constraints
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    
    // MARK: - Views
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(loginRegisterTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = ChainedTextField()
        textField.backgroundColor = .white
        textField.placeholder = "Name"
        textField.setLeftPadding(8)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.nextField = emailTextField
        textField.isHidden = true
        
        return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = ChainedTextField()
        textField.backgroundColor = .white
        textField.placeholder = "Email"
        textField.setLeftPadding(8)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.nextField = passTextField
        
        return textField
    }()
    
    lazy var passTextField: ChainedTextField = {
        let textField = ChainedTextField()
        textField.backgroundColor = .white
        textField.placeholder = "Password"
        textField.setLeftPadding(8)
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done

        return textField
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    var separatorView: UIView {
        get {
            let separatorView = UIView()
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([separatorView.heightAnchor.constraint(equalToConstant: 2)])
            separatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            
            return separatorView
        }
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = chatImage
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    fileprivate var activeView: UIView?
    
    // MARK: - Setup
    
    init(vm: LoginVMType) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func setupLayout() {
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(inputsContainerView)
        contentScrollView.addSubview(loginRegisterButton)
        contentScrollView.addSubview(profileImageView)
        contentScrollView.addSubview(loginRegisterSegmentedControl)
        
        contentScrollView.fillSuperviewSafeArea()
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    private func setupInputsContainerView() {
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            inputsContainerView.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: contentScrollView.centerYAnchor, constant: 40),
            inputsContainerView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor, constant: -24),
            inputContainerViewHeightAnchor!
            ])
        
        inputsContainerView.addSubview(inputStackView)
        inputStackView.fillSuperview()
        
        inputStackView.addArrangedSubview(nameTextField)
        inputStackView.addArrangedSubview(separatorView)
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(separatorView)
        inputStackView.addArrangedSubview(passTextField)
    }
    
    private func setupLoginRegisterButton() {
        NSLayoutConstraint.activate([
            loginRegisterButton.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    private func setupLoginRegisterSegmentedControl() {
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12),
            loginRegisterSegmentedControl.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 46)
            ])
    }
    
    private func setupProfileImageView() {
        NSLayoutConstraint.activate([profileImageView.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
                                     profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12),
                                     profileImageView.widthAnchor.constraint(equalToConstant: 150),
                                     profileImageView.heightAnchor.constraint(equalToConstant: 150)])
    }
    
    // MARK: - Handlers
    
    @objc func loginRegisterTapped() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            loginTapped()
        } else {
            registerTapped()
        }
    }
    
    @objc func loginTapped() {
        vm.login(email: emailTextField.text, password: passTextField.text)
    }
    
    @objc func registerTapped() {
        vm.register(email: emailTextField.text,
                    password: passTextField.text,
                    name: nameTextField.text,
                    image: profileImageView.image == addImage ? nil : profileImageView.image)
    }
    
    @objc func handleLoginRegisterChange() {
        let index = loginRegisterSegmentedControl.selectedSegmentIndex
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: index)
        loginRegisterButton.setTitle(title, for: .normal)
        
        profileImageView.contentMode = .scaleToFill
        
        if index == 0 {
            inputContainerViewHeightAnchor?.constant = 100
            nameTextField.isHidden = true
            profileImageView.isUserInteractionEnabled = false
            profileImageView.image = chatImage
        } else {
            inputContainerViewHeightAnchor?.constant = 150
            nameTextField.isHidden = false
            profileImageView.isUserInteractionEnabled = true
            profileImageView.image = addImage
        }
    }
    
    @objc func handleKeyboardDidShow(notification: Notification) {
        if let info = (notification as NSNotification).userInfo,
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = view.convert(keyboardFrame, from: nil).height
            
            contentScrollView.contentInset.bottom = keyboardHeight
            
            var contentFrame = contentScrollView.frame
            contentFrame.size.height -= keyboardHeight
            
            if let activeView = activeView {
                let targetRect = activeView.convert(activeView.bounds, to: contentScrollView)
                
                if !contentFrame.contains(CGPoint(x: 0, y: targetRect.maxY)) {
                    let offset = CGPoint(x: 0, y: targetRect.minY - keyboardHeight)
                    contentScrollView.setContentOffset(offset, animated: true)
                }
            }
        }
    }
    
    @objc func handleKeyboardDidHide(notification: Notification) {
        contentScrollView.contentInset = UIEdgeInsets.zero
    }
}

// MARK: - TextField delegate

extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeView = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let chainedTextField = textField as? ChainedTextField, let nextTextField = chainedTextField.nextField {
            nextTextField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeView = nil
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
