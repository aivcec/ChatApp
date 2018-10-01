//
//  ChatLogVC.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 23/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ChatLogVC: UIViewController {
    
    // MARK: - Properties
    
    fileprivate var startingFrame: CGRect?
    fileprivate var backgroundView: UIView?
    fileprivate var startingImageView: UIImageView?
    fileprivate let collectionContentInset = UIEdgeInsets(top: 8, left: 0, bottom: 5, right: 0)
    private var vm: ChatLogVMType!
    
    // MARK: - Views
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: ChatMessageCell.className)
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 5, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.keyboardDismissMode = .interactive
        return collectionView
    }()
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.delegate = self
        
        return chatInputContainerView
    }()
    
    // MARK: - Responder
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // MARK: - Setup
    
    init(vm: ChatLogVMType) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = vm.user.name
        
        setupLayout()
        vm.viewDelegate = self
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
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
}

// MARK: - Handlers

extension ChatLogVC {
    @objc func handleKeyboardDidShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            collectionView.contentInset = collectionContentInset
            collectionView.contentInset.bottom += keyboardFrame.height
            scrollToBottom()
        }
    }
    
    @objc func handleKeyboardDidHide(notification: Notification) {
        collectionView.contentInset = collectionContentInset
    }
    
    func scrollToBottom() {
        if vm.messageData.count > 0 {
            collectionView.scrollToItem(at: IndexPath(item: vm.messageData.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
}

// MARK: - ChatLogVMViewDelegate

extension ChatLogVC: ChatLogVMViewDelegate {
    
    func messageSent() {
        inputContainerView.inputTextField.text = nil
    }
    
    func messageArrived() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToBottom()
        }
    }
    
    func setNavigationTitle(_ title: String?) {
        navigationItem.title = title
    }
}

// MARK: - ChatInputContainerViewDelegate

extension ChatLogVC: ChatInputContainerViewDelegate {
    
    func handleUpload() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    func handleSend() {
        vm.sendMessageWith(text: inputContainerView.inputTextField.text)
    }
}

// MARK: - UImagePicker Delegate

extension ChatLogVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        if let videoUrl = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL {
            vm.sendMessageWith(videoUrl: videoUrl)
        } else {
            var pickedImage: UIImage?
            
            if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                pickedImage = editedImage
            } else if let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                pickedImage = originalImage
            }
            
            vm.sendMessageWith(image: pickedImage)
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - CollectionView DataSource

extension ChatLogVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.messageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageCell.className, for: indexPath) as! ChatMessageCell
        
        let messageData = vm.messageData[indexPath.item]
        cell.setupWith(messageData: messageData)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = vm.messageData[indexPath.item].message
        
        
        if let text = message.text {
            let height = CGRect.estimatedFrameForText(text: text).height
            
            return CGSize(width: view.frame.width, height: height + 20)
            
        } else if let width = message.imageWidth?.doubleValue, let height = message.imageHeight?.doubleValue {
            let height = CGFloat(200 * (height/width))
            
            return CGSize(width: view.frame.width, height: height)
        }
        
        //may be better to use screen width
        return CGSize(width: view.frame.width, height: 80)
    }
}

//MARK: - ChatMessageCellDelegate

extension ChatLogVC: ChatMessageCellDelegate {
    
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        inputContainerView.inputTextField.resignFirstResponder()
        
        startingFrame = startingImageView.convert(startingImageView.bounds, to: nil)
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.backgroundColor = .red
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        zoomingImageView.isUserInteractionEnabled = true
        
        if let keyWindow = UIApplication.shared.keyWindow, let imageSize = startingImageView.image?.size {
            backgroundView = UIView()
            backgroundView?.translatesAutoresizingMaskIntoConstraints = true
            backgroundView?.backgroundColor = .black
            backgroundView?.alpha = 0
            
            keyWindow.addSubview(backgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            backgroundView?.fillSuperview()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.backgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                let width = keyWindow.frame.width
                let height = width*(imageSize.height/imageSize.width)
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view as? UIImageView {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                zoomOutImageView.layer.cornerRadius = 16
                zoomOutImageView.layer.masksToBounds = true
                self.backgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { completed in
                zoomOutImageView.removeFromSuperview()
                self.backgroundView?.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
