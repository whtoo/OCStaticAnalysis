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
            nodeTree.append(walk())
        }
        resetIndex()
        return nodeTree
    }
    // LL
    private func walk() -> JNode {
        var tk = _currrnetTk
        var jNode = JNode()
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
                jNode.params.append(walk())
                tk = _currrnetTk
            }
            // 跳到下一个
            advance()
            return jNode
        }
        
        advance()
        return jNode
    }
}
