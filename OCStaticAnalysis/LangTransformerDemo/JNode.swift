//
//  JNumberType.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/14.
//

import Foundation

public enum JNumberType: String {
    case int
    case float
}

public enum JNodeType: String {
    case Root
    case None
    case NumberLiteral
    case CallExpression
    case Identifier
    case ExpressionStatement
}

public protocol JNodeBase {
    var type: JNodeType { get }
    var name: String { get }
    var params: [JNode] { get }
}

public protocol JNumberLiteral {
    var numberType: JNumberType { get }
    var intValue: Int { get }
    var floatValue: Float { get }
}



public class JNode: JNodeBase, JNumberLiteral {
    public var type: JNodeType = JNodeType.None
    
    public var name: String = ""
    
    public var params: [JNode] = [JNode]()
    
    public var numberType: JNumberType = JNumberType.int
    
    public var intValue: Int = 0
    
    public var floatValue: Float = 0
    
    public var expressions: [JNode] = [JNode]()
    
}

public class JNodeCallee: JNode {
    public var callee: JNode?
}

protocol Printable {
    var desc: String { get }
}
