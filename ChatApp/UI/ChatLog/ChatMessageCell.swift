//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 29/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit
import AVFoundation

protocol ChatMessageCellDelegate: class {
    func performZoomInForStartingImageView(_ imageView: UIImageView)
}

class ChatMessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: ChatMessageCellDelegate?
    
    fileprivate var videoUrl: String?
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var player: AVPlayer?
    
    fileprivate static let blueColor: UIColor = UIColor(r: 0, g: 137, b: 249)
    fileprivate static let grayColor: UIColor = UIColor(r: 240, g: 240, b: 240)
    
    // MARK: - Constraints
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    // MARK: - Views
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor =  .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isUserInteractionEnabled = false
        textView.textColor = .white
        textView.isEditable = false
        
        return textView
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = blueColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return imageView
    }()
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        
        bubbleViewLeftAnchor =  bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewRightAnchor?.isActive = false
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: topAnchor),
            bubbleView.heightAnchor.constraint(equalTo: heightAnchor),
            bubbleWidthAnchor!,
            bubbleViewRightAnchor!
            ])
        
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8),
            textView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
        
        addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 32)
            ])
        
        bubbleView.addSubview(messageImageView)
        
        NSLayoutConstraint.activate([
            messageImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor)
            ])
        
        bubbleView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        bubbleView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(messageData: ChatMessageCellData) {
        
        videoUrl = messageData.message.videoUrl
        
        if messageData.isOutgoing {
            //outgoing blue
            
            bubbleView.backgroundColor = ChatMessageCell.blueColor
            textView.textColor = .white
            bubbleViewLeftAnchor?.isActive = false
            bubbleViewRightAnchor?.isActive = true
            profileImageView.isHidden = true
        } else {
            //incoming gray
            if let profileImageUrl = messageData.profileImageUrl {
                profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            }
            
            bubbleView.backgroundColor = ChatMessageCell.grayColor
            textView.textColor = .black
            bubbleViewRightAnchor?.isActive = false
            bubbleViewLeftAnchor?.isActive = true
            profileImageView.isHidden = false
        }
        
        if let text = messageData.message.text {
            textView.text = text
            bubbleWidthAnchor?.constant = CGRect.estimatedFrameForText(text: text).width + 32
            messageImageView.isHidden = true
            textView.isHidden = false
        } else if let imageUrl = messageData.message.imageUrl {
            messageImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
            bubbleWidthAnchor?.constant = 200
            messageImageView.isHidden = false
            textView.isHidden = true
        }
        
        playButton.isHidden = messageData.message.videoUrl == nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    //MARK: Handlers
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            delegate?.performZoomInForStartingImageView(imageView)
        }
    }
    
    @objc func handlePlay() {
        
        activityIndicatorView.startAnimating()
        if let videoURLString = videoUrl, let url = URL(string: videoURLString)  {
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer!.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
        }
    }
}
