//
//  XPCServiceDemoTitleLabelService+Extensions.swift
//  XPCServiceDemoTitleLabelService
//
//  Created by Marek Přidal on 17.03.2021.
//

import Foundation

@objc
final class XPCServiceDemoTitleLabelService: NSObject, XPCServiceDemoTitleLabelServiceProtocol {
    func setDogAgeFor(_ dogs: [Dog], withReply reply: @escaping ([Dog]) -> Void) {
        reply(dogs.map { Dog(name: $0.name, age: NSNumber(integerLiteral: Int.random(in: 1...10))) })
    }

    func setDogAgeFor(_ aDog: Dog, withReply reply: @escaping (Dog) -> Void) {
        reply(.init(name: aDog.name, age: 10))
    }

    func dogNames(for dogs: [Dog], withReply reply: @escaping ([String]) -> Void) {
        reply(dogs.map { $0.name })
    }

    func dogName(for aDog: Dog, withReply reply: @escaping (String) -> Void) {
        reply(aDog.name)
    }

    func upperCaseString(_ aString: String, withReply reply: @escaping (String) -> Void) {
        reply(aString.uppercased())
    }
    
    func lowerCaseString(_ aString: String, withReply reply: @escaping (String) -> Void) {
        reply(aString.lowercased())
    }
}
