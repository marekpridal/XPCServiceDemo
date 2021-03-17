//
//  SwiftViewController.swift
//  XPCServiceDemo
//
//  Created by Marek Přidal on 17.03.2021.
//

import Cocoa
import XPCServiceDemoSwiftService

final class SwiftViewController: NSViewController {
    @IBOutlet private weak var establishConnectionButton: NSButton!
    @IBOutlet private weak var invalidateConnectionButton: NSButton!
    @IBOutlet private weak var actionButton: NSButton!
    @IBOutlet private weak var clearButton: NSButton!
    @IBOutlet private weak var label: NSTextField!
    @IBOutlet private weak var connectionStatus: NSTextField!

    private var connection: NSXPCConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        establishConnectionButton.title = "Establish connection"
        invalidateConnectionButton.title = "Invalidate Connection"
        connectionStatus.stringValue = ""
        actionButton.title = "Action button"
        clearButton.title = "Clear button"
        clearButtonPressed()

        establishConnectionButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(establishSwiftConnection)))
//        establishConnectionButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(establishObjcConnection)))
        invalidateConnectionButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(invalidateButtonPressed)))
        actionButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(actionButtonPressed)))
        clearButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(clearButtonPressed)))
    }
    
    @objc private func establishObjcConnection() {
        let connection = NSXPCConnection(serviceName: XPCServiceDemoTitleLabelServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCServiceDemoTitleLabelServiceProtocol.self)
        connection.resume()
        connectionStatus.stringValue = "Connected to service \(connection.serviceName ?? "")"
        connection.interruptionHandler = { [weak connectionStatus] in
            DispatchQueue.main.async { [weak connectionStatus] in
                connectionStatus?.stringValue = "Connection has been interrupted but still valid."
            }
        }
        connection.invalidationHandler = {[weak connectionStatus] in
            DispatchQueue.main.async { [weak connectionStatus] in
                connectionStatus?.stringValue = "Connection has been invalidated. Need to reestablish connection."
            }
        }
        self.connection = connection
    }
    
    @objc private func establishSwiftConnection() {
        let connection = NSXPCConnection(serviceName: "eu.marekpridal.XPCServiceDemoSwiftService")
        connection.remoteObjectInterface = NSXPCInterface(with: XPCServiceDemoSwiftServiceProtocol.self)
        connection.resume()
        connectionStatus.stringValue = "Connected to service \(connection.serviceName ?? "")"
        connection.interruptionHandler = { [weak connectionStatus] in
            DispatchQueue.main.async { [weak connectionStatus] in
                connectionStatus?.stringValue = "Connection has been interrupted but still valid."
            }
        }
        connection.invalidationHandler = {[weak connectionStatus] in
            DispatchQueue.main.async { [weak connectionStatus] in
                connectionStatus?.stringValue = "Connection has been invalidated. Need to reestablish connection."
            }
        }
        self.connection = connection
    }

    @objc private func invalidateButtonPressed() {
        connection?.invalidate()
    }

    @objc private func actionButtonPressed() {
        swiftUpperCase(string: "Hi")
//        objcUpperCase(string: "Hello")
    }
    
    private func objcUpperCase(string: String) {
        let service = connection?.remoteObjectProxyWithErrorHandler { [weak label] (error) in
            DispatchQueue.main.async { [weak label] in
                label?.stringValue = error.localizedDescription
            }
        } as? XPCServiceDemoTitleLabelServiceProtocol

        service?.upperCaseString(string, withReply: { [weak label] (result) in
            DispatchQueue.main.async { [weak label] in
                label?.stringValue = result ?? ""
            }
        })
    }
    
    private func swiftUpperCase(string: String) {
        let service = connection?.remoteObjectProxyWithErrorHandler { [weak label] (error) in
            DispatchQueue.main.async { [weak label] in
                label?.stringValue = error.localizedDescription
            }
        } as? XPCServiceDemoSwiftService.XPCServiceDemoSwiftServiceProtocol

        service?.upperCaseString(string, withReply: { [weak label] (result) in
            DispatchQueue.main.async { [weak label] in
                label?.stringValue = result
            }
        })
    }

    @objc private func clearButtonPressed() {
        label.stringValue = ""
    }
}
