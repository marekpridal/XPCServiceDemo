//
//  XPCServiceDemoTitleLabelService+Extensions.swift
//  XPCServiceDemoTitleLabelService
//
//  Created by Marek Přidal on 17.03.2021.
//

import Foundation

@objc
final class XPCServiceDemoTitleLabelService: NSObject, XPCServiceDemoTitleLabelServiceProtocol {
    func upperCaseString(_ aString: String, withReply reply: @escaping (String) -> Void) {
        reply(aString.uppercased())
    }
    
    func lowerCaseString(_ aString: String, withReply reply: @escaping (String) -> Void) {
        reply(aString.lowercased())
    }
}
