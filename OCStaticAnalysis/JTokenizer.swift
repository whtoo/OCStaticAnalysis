//
//  File.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/13.
//

import Foundation

extension String {
    func isInt() -> Bool {
        let scan:Scanner = Scanner(string: self)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    func isFloat() -> Bool {
        let scan:Scanner = Scanner(string: self)
        
        if scan.scanFloat(representation: .decimal) != nil {
            return scan.isAtEnd
        }
        
        return  false
    }
}
