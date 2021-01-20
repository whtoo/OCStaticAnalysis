//
//  main.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/13.
//

import Foundation

//let input = "(multiple (add 2 3.1) 4)"
//
//let generator = CodeGeneratorFromJSToOC(input)

let file = "/Users/blitz/Documents/OCStaticAnalysis/OCStaticAnalysis/OurClass.m"
let sourceCode = try! String(contentsOfFile: file)
let interpreter = OCInterpreter(sourceCode)

