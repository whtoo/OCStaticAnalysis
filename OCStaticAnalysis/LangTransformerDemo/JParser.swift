//
//  JParser.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/14.
//

import Foundation
// expr : "(" expr ")"
// expr : callexpr
// callexpr : "(" ID params ")"
//
public class JParser {
    private var _tokens: [JToken]
    private var _current: Int
    private var _currrnetTk: JToken {
        return _tokens[_current]
    }
    init(_ input: String) {
        _tokens = JTokenizer(input).tokenizer()
        _current = 0
    }
    
    private func resetIndex() {
        _current = 0
    }
    
    private func advance() {
        if _current < _tokens.endIndex {
            _current += 1
        }
    }
    public func parser() -> [JNode] {
        resetIndex()
        var nodeTree = [JNode]()
        while _current < _tokens.count {
            nodeTree.append(program())
        }
        resetIndex()
        return nodeTree
    }
    // LL
    // Program -> Number | CallExpr
    // Number -> Int | Float
    // CallExpr -> "(" Id Params ")"
    // Int -> Digits
    // Float -> Int "." Int
    // Digit -> 0..9
    // Digits -> Digit+
    // Params -> Param*
    // Param -> Number | CallExpr
    
    private func program() -> JNode {
        var tk = _currrnetTk
        let jNode = JNode()
        //检查是不是数字节点
        if let numNode = number() {
           return numNode
        }
        //检查是否CallExpression
        if tk.type == "paren" && tk.value == "(" {
            //跳过符号
            advance()
            tk = _currrnetTk
            
            jNode.type = .CallExpression
            jNode.name = tk.value
            advance()
            while tk.type != "paren" || (tk.type == "paren" && tk.value != ")") {
                //递归下降
                jNode.params.append(program())
                tk = _currrnetTk
            }
            // 跳到下一个
            advance()
            return jNode
        }
        
        advance()
        return jNode
    }

    func number() -> JNode? {
        let tk = _currrnetTk
        let jNode = JNode()
        //检查是不是数字节点
        if tk.type == "int" || tk.type == "float" {
            advance()
            jNode.type = .NumberLiteral
            if tk.type == "int", let intV = Int(tk.value) {
                jNode.intValue = intV
                jNode.numberType = .int
            }
            if tk.type == "float", let floatV = Float(tk.value) {
                jNode.floatValue = floatV
                jNode.numberType = .float
            }
            
            return jNode
        }
        return nil
    }
    // -------- 打印AST， 方便调试 ---------
    static func astPrintable(_ tree: [JNode]) {
        for aNode in tree {
            recDesNode(aNode, level: 0)
        }
    }
    
    static private func recDesNode(_ node: JNode, level: Int) {
        let nodeTypeStr = node.type
        var preSpace = ""
        for _ in 0...level {
            preSpace += "  "
        }
        
        var dataStr = ""
        switch node.type {
        case .NumberLiteral:
            var numberStr = ""
            if node.numberType == .int {
                numberStr = "\(node.intValue)"
            } else if node.numberType == .float {
                numberStr = "\(node.floatValue)"
            }
            dataStr = "number type is \(node.numberType) number is \(numberStr)"
            print("\(preSpace) \(dataStr)")
        case .CallExpression:
            dataStr = "expression is \(node.type) (\(node.name))"
            print("\(preSpace) \(nodeTypeStr) \(dataStr)")
            
            if node.params.count > 0 {
                for aNode in node.params {
                    recDesNode(aNode, level: level+1)
                }
            }
        case .None:
            dataStr = ""
        case .Root:
            dataStr = "Root node"
            print("\(preSpace) \(dataStr)")
        case .Identifier:
            dataStr = "identifier node \(node.name)"
        case .ExpressionStatement:
            dataStr = "expression-statement node"
            print("\(preSpace) \(nodeTypeStr) \(dataStr)")

            if node.expressions.count > 0 {
                for aNode in node.expressions {
                    recDesNode(aNode, level: level+1)
                }
            }
        }
        
    }
}
