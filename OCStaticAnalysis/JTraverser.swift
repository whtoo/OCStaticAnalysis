//
//  JTraverser.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/14.
//

import Foundation

public typealias VisitorClosure = (_ node:JNode,_ parent:JNode) -> Void

public class JTraverser {
    
    private var _ast: [JNode]
    
    public init(_ input: String) {
        _ast = JParser(input).parser()
    }
    
    fileprivate func traverseNnode(_ visitor:[String:VisitorClosure],node:JNode, parent:JNode,transformer:JTransformer) {
        if visitor.keys.contains(node.type.rawValue) {
            if let closure: VisitorClosure = visitor[node.type.rawValue] {
                closure(node,parent)
            }
        }
        if node.type == .CallExpression {
            // 看看是否有子节点需要遍历
            if node.params.count > 0 {
                traverseChildNode(visitor,childrens: node.params, parent: node,transformer: transformer)
                transformer.popParent()
            }// exit
            
        } else if node.type == .ExpressionStatement {
            // 看看是否有子节点需要遍历
            if node.expressions.count > 0 {
                traverseChildNode(visitor,childrens: node.expressions, parent: node,transformer: transformer)
                transformer.popParent()
            }// exit
        }
       
       
    }
    
    fileprivate func traverseChildNode(_ visitor:[String:VisitorClosure],childrens:[JNode],parent:JNode,transformer:JTransformer) {
        for child in childrens {
            traverseNnode(visitor,node: child, parent: parent,transformer: transformer)
        }
    }
    
    public func traverser(visitor:[String:VisitorClosure],transformer:JTransformer) {
        let rootNode = JNode()
        rootNode.type = .Root
        traverseChildNode(visitor,childrens: _ast, parent: rootNode,transformer: transformer)
    }
}
