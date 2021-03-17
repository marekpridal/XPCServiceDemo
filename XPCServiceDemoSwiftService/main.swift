//
//  main.m
//  XPCServiceDemoSwiftService
//
//  Created by Marek Přidal on 17.03.2021.
//

import Foundation

final class MyServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = XPCServiceDemoSwiftServiceModel()
        newConnection.exportedInterface = NSXPCInterface(with: XPCServiceDemoSwiftServiceProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}

let delegate = MyServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
