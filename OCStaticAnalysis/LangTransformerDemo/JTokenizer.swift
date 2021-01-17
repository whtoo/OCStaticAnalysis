//
//  File.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/13.
//

import Foundation

public class JTokenizer {
    private var _input: String
    private var _index: String.Index
    
    init(_ input: String) {
        _input = input.filterAnnotationBlock()
        _index = _input.startIndex
    }
    
    fileprivate func advanceIndex() {
        _index = _input.index(after: _index)
    }
    
    fileprivate var currentChar: Character? {
        get {
            return _index < _input.endIndex ? _input[_index] : nil
        }
    }
    
    public func tokenizer() -> [JToken] {
        var tokens = [JToken]()
        while let aChar = currentChar {
            let s = aChar.description
            let symbols = ["(",")"," "]
            if symbols.contains(s) {
                if s == " " {
                    //Skip whitespace
                    advanceIndex()
                    continue
                }
                tokens.append(JToken(type: "paren", value: s))
                advanceIndex()
                continue
            } else {
                var word = ""
                while let aChar = currentChar {
                    let str = aChar.description
                    if(symbols.contains(str)) {
                        break
                    }
                    word.append(str)
                    advanceIndex()
                    continue
                }
                
                if word.count > 0 {
                    var tkType = "char"
                    if word.isInt() {
                       tkType = "int"
                    }else if word.isFloat() {
                        tkType = "float"
                    }
                    tokens.append(JToken(type: tkType, value: word))
                }
            }// End if
        }//End while
        return tokens
    }
    
    
}
