//
//  ChatInputContainerView.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 14/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

protocol ChatInputContainerViewDelegate: class {
    func handleUpload()
    func handleSend()
}

class ChatInputContainerView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ChatInputContainerViewDelegate?
    
    // MARK: - Views
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "upload_image_icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadTapped)))
        
        return imageView
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        return view
    }()
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(uploadImageView)
        addSubview(sendButton)
        addSubview(inputTextField)
        addSubview(separatorLineView)
        
        setupUploadImageView()
        setupSendButton()
        setupInputTextField()
        setupSeparatorLineView()
    }
    
    private func setupUploadImageView() {
        NSLayoutConstraint.activate([
            uploadImageView.leftAnchor.constraint(equalTo: leftAnchor),
            uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            uploadImageView.heightAnchor.constraint(equalToConstant: 44),
            uploadImageView.widthAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    private func setupSendButton() {
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: rightAnchor),
            sendButton.heightAnchor.constraint(equalTo: heightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    
    private func setupInputTextField() {
        NSLayoutConstraint.activate([
            inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8),
            inputTextField.heightAnchor.constraint(equalTo: heightAnchor),
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 8)
            ])
    }
    
    private func setupSeparatorLineView() {
        NSLayoutConstraint.activate([
            separatorLineView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorLineView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorLineView.topAnchor.constraint(equalTo: topAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
    
    //MARK: - Handlers
    
    @objc func uploadTapped() {
        delegate?.handleUpload()
    }
    
    @objc func sendTapped() {
        delegate?.handleSend()
    }
}

// MARK: - Extensions

extension ChatInputContainerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.handleSend()
        return true
    }
}
