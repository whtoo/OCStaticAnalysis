//
//  StringExtensions.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/13.
//

import Foundation

extension String {
    func isInt() -> Bool {
        let scan:Scanner = Scanner(string: self)
        
        if scan.scanInt(representation: .decimal) != nil {
            return scan.isAtEnd
        }
        
        return false
    }
    
    func isFloat() -> Bool {
        let scan:Scanner = Scanner(string: self)
        
        if scan.scanFloat(representation: .decimal) != nil {
            return scan.isAtEnd
        }
        
        return  false
    }
    func filterAnnotationBlock() -> String {
        //过滤注释
        var newStr = ""
        let annotationBlockPattern = "/\\*[\\s\\S]*?\\*" //匹配/*...*/这样的注释
        let regexBlock = try! NSRegularExpression(pattern: annotationBlockPattern, options: NSRegularExpression.Options(rawValue: 0))
        newStr = regexBlock.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        return newStr
    }
}
