//
//  ClassName.swift
//  OctCats
//
//  Created by arabian9ts on 2019/09/01.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
