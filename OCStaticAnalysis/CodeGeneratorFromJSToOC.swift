//
//  CodeGeneratorFromJSToOC.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/16.
//

import Foundation

public class CodeGeneratorFromJSToOC {
    public var code = ""
    public init(_ input:String) {
        print("Input code is:")
        print(input)
        let ast = JTransformer(input).ast
        for aNode in ast {
            code.append(recGeneratorCode(aNode))
        }
        print("The code generated:")
        print(code)
    }

    public func recGeneratorCode(_ node:JNode) -> String {
        var code = ""
        if node.type == .ExpressionStatement {
            for aExp in node.expressions {
                code.append(recGeneratorCode(aExp))
            }
        }
        if node.type == .CallExpression {
            let calleeNode = node as! JNodeCallee
            code.append(calleeNode.callee!.name)
            code.append("(")
            if node.params.count > 0 {
                for (index,arg) in node.params.enumerated() {
                    code.append(recGeneratorCode(arg))
                    if index != node.params.count - 1 {
                        code.append(", ")
                    }
                }
            }
            code.append(")")
        }
        if node.type == .Identifier {
            code.append(node.name)
        }
        if node.type == .NumberLiteral {
            switch node.numberType {
            case .float:
                code.append(String(node.floatValue))
            case .int:
                code.append(String(node.intValue))
            }
        }

        return code
    }
}
