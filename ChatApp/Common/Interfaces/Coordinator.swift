//
//  Coordinator.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 14/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    
    func start()
    func finish()
}
