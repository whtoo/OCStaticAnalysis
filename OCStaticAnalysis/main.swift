//
//  main.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/13.
//

import Foundation

let input = "(multiple (add 2 3) 4)"

let tokens = JTokenizer.init(input).tokenizer()
print("\(tokens)")


