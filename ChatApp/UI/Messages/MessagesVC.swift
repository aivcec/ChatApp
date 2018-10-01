//
//  MessagesVC.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 20/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController {
    
    // MARK: - Properties
    
    private var vm: MessagesVMType!
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.className)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    // MARK: - Setup
    
    init(vm: MessagesVMType) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(newMessageTapped))
        
        setupLayout()
        vm.viewDelegate = self
    }
    
    func setNavBarWithUser(user: User) {
        let titleView = UIView()
        titleView.backgroundColor = .red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
            ])
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40)
            ])
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor)
            ])
        
        navigationItem.titleView = titleView
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    // MARK: - Handlers
    
    @objc func logoutTapped() {
        vm.handleLogout()
    }
    
    @objc func newMessageTapped() {
        vm.handleNewMessage()
    }
}

// MARK: - MessagesVMViewDelegate

extension MessagesVC: MessagesVMViewDelegate {
    func reloadRequired() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupWithUser(_ user: User) {
        setNavBarWithUser(user: user)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableView Delegate and DataSource

extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        vm.handleDeleteAt(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.messagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.className, for: indexPath) as! UserCell
        
        cell.setupWith(cellData: vm.messagesData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.handleTapAt(row: indexPath.row)
    }
}
