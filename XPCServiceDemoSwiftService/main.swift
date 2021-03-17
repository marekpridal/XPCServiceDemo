//
//  main.m
//  XPCServiceDemoSwiftService
//
//  Created by Marek Přidal on 17.03.2021.
//

import Foundation

final class XPCServiceDemoSwiftServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = XPCServiceDemoSwiftServiceModel()
        newConnection.exportedInterface = NSXPCInterface(with: XPCServiceDemoSwiftServiceProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}

let delegate = XPCServiceDemoSwiftServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
// RunLoop.main.run() Not sure if necessary
