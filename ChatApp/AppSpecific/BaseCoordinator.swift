//
//  BaseCoordinator.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 26/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit


class BaseCoordinator: Coordinator {
    
    let rootNC: UINavigationController
    private(set) var childCoordinators: [Coordinator] =  []
    
    init(rootNC: UINavigationController) {
        self.rootNC = rootNC
    }
    
    func start() {
        preconditionFailure("Method not implemented.")
    }
    
    func finish() {
        preconditionFailure("Method not implemented.")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.index(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

extension BaseCoordinator: ServiceDelegateProtocol {
    
    func serviceDidStartRequest(_ service: Service, withIndicator showIndicator: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        if showIndicator {
            SVProgressHUD.show()
        }
    }
    
    func serviceDidSucceed(_ service: Service) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        SVProgressHUD.dismiss()
    }
    
    func service(_ service: Service, didFailWithErrorTitle errorTitle: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        SVProgressHUD.showError(withStatus: errorTitle)
    }
}
