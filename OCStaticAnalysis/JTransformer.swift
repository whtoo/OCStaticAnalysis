//
//  JTransformer.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/14.
//

import Foundation

public class JTransformer {
    public var ast:[JNode]
    /// TODO :  父节点需要使用栈管理
    public init(_ input: String) {
        ast = [JNode]()
        var parentStack = [JNode]()
        parentStack.append(JNode())
        var currentParent = parentStack.last!
        let numberLiteralClosure:VisitorClosure = { (node,parent) in
            if currentParent.type == .ExpressionStatement {
                currentParent.expressions[0].params.append(node)
            }
            if currentParent.type == .CallExpression{
                currentParent.params.append(node)
            }
        }
        let callExpressionClosure:VisitorClosure = { (node,parent) in
            let exp = JNodeCallee()
            exp.type = .CallExpression
            
            let callee = JNode()
            callee.type = .Identifier
            callee.name = node.name
            exp.callee = callee
            
            if parent.type != .CallExpression {
                let exps = JNode()
                exps.type = .ExpressionStatement
                exps.expressions.append(exp)
                if parent.type == .Root {
                    self.ast.append(exps)
                }
                currentParent = exps
            }
            else {
                currentParent.expressions[0].params.append(exp)
                currentParent = exp
            }
        }
        
            let vDic = ["NumberLiteral": numberLiteralClosure, "CallExpression" : callExpressionClosure]
    
            JTraverser(input).traverser(visitor: vDic)
            print("After transform AST:")
            JParser.astPrintable(ast)
    }
}
