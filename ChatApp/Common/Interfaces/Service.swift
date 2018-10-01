//
//  BaseService.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 26/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

protocol ServiceDelegateProtocol: class {
    func serviceDidStartRequest(_ service: Service, withIndicator showIndicator: Bool)
    func serviceDidSucceed(_ service: Service)
    func service(_ service: Service, didFailWithErrorTitle errorTitle: String)
}

protocol Service {
    var delegate: ServiceDelegateProtocol? { get }
}
