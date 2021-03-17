//
//  SwiftViewController.swift
//  XPCServiceDemo
//
//  Created by Marek Přidal on 17.03.2021.
//

import AppKit
import XPCServiceDemoSwiftService

final class SwiftViewController: NSViewController {
    
    private func establishConnection() {
        let connection = NSXPCConnection(serviceName: "eu.marekpridal.XPCServiceDemoSwiftService")
        connection.remoteObjectInterface = NSXPCInterface(with: XPCServiceDemoSwiftServiceProtocol.self)
        
        let service = connection.remoteObjectProxyWithErrorHandler { (error) in
            print(error.localizedDescription)
        } as? XPCServiceDemoSwiftServiceModel
        
        service?.upperCaseString("Hi", withReply: { (result) in
            print(result)
        })
    }
}
