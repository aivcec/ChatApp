//
//  UserCell.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 21/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Views
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode  = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Setup
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48)
            ])
        
        NSLayoutConstraint.activate([
            timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(cellData: UserCellData) {
        
        detailTextLabel?.text = cellData.displayText()
        textLabel?.text = cellData.user.name
        
        if let seconds = cellData.message.timestamp?.doubleValue {
            setupTimeLabel(seconds: seconds)
        }
        
        if let imageUrl = cellData.user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
    private func setupTimeLabel(seconds: Double) {
        let timestampDate = Date(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        timeLabel.text = dateFormatter.string(from: timestampDate)
    }
    
    //manually setting frames
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let textLabel = textLabel {
            textLabel.frame = CGRect(x: 64, y: textLabel.frame.minY - 2, width: textLabel.frame.width, height: textLabel.frame.height)
        }
        
        if let detailLabel = detailTextLabel {
            detailLabel.frame = CGRect(x: 64, y: detailLabel.frame.minY + 2, width: detailLabel.frame.width, height: detailLabel.frame.height)
        }
    }
}
