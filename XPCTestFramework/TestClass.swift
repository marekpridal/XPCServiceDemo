//
//  TestClass.swift
//  XPCTestFramework
//
//  Created by Marek Přidal on 17.03.2021.
//

import Foundation

@objc
public final class TestClass: NSObject {
    @objc var foo: String?

    @objc
    public override init() {
        super.init()
    }
}
