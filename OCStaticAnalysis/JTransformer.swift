//
//  JTransformer.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/14.
//

import Foundation

public class JTransformer {
    public var ast:[JNode]
    
    public init(_ input: String) {
        ast = [JNode]()
        var currentParent = JNode()
        let numberLiteralClosure:VisitorClosure = { (node,parent) in
            if currentParent.type == .CallExpression{
                currentParent.params.append(node)
            }
        }
        let callExpressionClosure:VisitorClosure = { (node,parent) in
            var exp = JNodeCallExpression()
            
            var callee = JNode()
            callee.type = .Identifier
            callee.name = node.name
            exp.callee = callee
            
            
            
        }
    }
}
