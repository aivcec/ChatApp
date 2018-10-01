//
//  NewMessageVC.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 21/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

class NewMessageVC: UIViewController {
    
    // MARK: - Properties
    
    private var vm: NewMessageVMType!
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.className)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    // MARK: - Setup
    
    init(vm: NewMessageVMType) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    
        setupLayout()
        vm.viewDelegate = self
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    // MARK: - Actions
    
    @objc func cancelTapped() {
        vm.handleCancel()
    }
}

// MARK: - NewMessageVMViewDelegate

extension NewMessageVC: NewMessageVMViewDelegate {
    func reloadRequired() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableView Delegate and DataSource

extension NewMessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = vm.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.className, for: indexPath) as! UserCell
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.handleTapAt(row: indexPath.row)
    }
}
