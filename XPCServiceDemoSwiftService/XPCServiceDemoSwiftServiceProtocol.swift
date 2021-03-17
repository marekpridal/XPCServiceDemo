//
//  XPCServiceDemoSwiftServiceProtocol.swift
//  XPCServiceDemoSwiftService
//
//  Created by Marek Přidal on 17.03.2021.
//

import Foundation

@objc
public protocol XPCServiceDemoSwiftServiceProtocol {
    func upperCaseString(_ aString: String, withReply reply: @escaping (String) -> Void)
}
