//
//  JTransformer.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/14.
//

import Foundation

public class JTransformer {
    public var ast:[JNode]
    private var parentStack:[JNode] = [JNode]()
    private var currentParent: JNode {
        return parentStack.last!
    }
    
    public func popParent() -> Bool {
        return parentStack.popLast() != nil
    }
    
    /// TODO :  父节点需要使用栈管理
    public init(_ input: String) {
        ast = [JNode]()
        var parentStack = [JNode]()
        let rootNode = JNode()
        rootNode.type = .Root
        parentStack.append(rootNode)
        let numberLiteralClosure:VisitorClosure = { (node,parent) in
            if self.currentParent.type == .ExpressionStatement {
                self.currentParent.expressions[0].params.append(node)
            }
            if self.currentParent.type == .CallExpression{
                self.currentParent.params.append(node)
            }
        }
        let callExpressionClosure:VisitorClosure = { (node,parent) in
            let exp = JNodeCallee()
            exp.type = .CallExpression
            exp.name = node.name
            
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
                self.parentStack.append(exps)
            }
            else {
                self.currentParent.expressions[0].params.append(exp)
                self.parentStack.append(exp)
            }
        }
        
        let vDic = ["NumberLiteral": numberLiteralClosure, "CallExpression" : callExpressionClosure]

        JTraverser(input).traverser(visitor: vDic,transformer: self)
        print("After transform AST:")
        JParser.astPrintable(ast)
    }
}
