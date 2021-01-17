//
//  OCSymbol.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/17.
//

import Foundation

protocol OCSymbol {
    var name: String { get }
}

public enum OCBuiltInTypeSymbol: OCSymbol {
    case integer
    case float
    case boolean
    case string
    
    var name: String {
        switch self {
        case .integer:
            return "NSUInteger"
        case .float:
            return "CGFloat"
        case .boolean:
            return "BOOL"
        case .string:
            return "NSString"
        }
    }
}

class OCVariableSymbol: OCSymbol {
    let name: String
    let type: OCSymbol
    init(name:String,type:OCSymbol) {
        self.name = name
        self.type = type
    }
}
 
