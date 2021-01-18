//
//  OCStaticAnalyzer.swift
//  OCStaticAnalysis
//
//  Created by blitz on 2021/1/18.
//

import Foundation

public class OCStaticAnalyzer : OCVisitor {
    
    private var currentScope: OCSymbolTable?
    private var scopes: [String: OCSymbolTable] = [:]
    
    public init() {
        
    }
    
    public func analyze(node: OCAST) -> [String: OCSymbolTable] {
        visit(node: node)
        return scopes
    }
    
    private func pushScope(name: String) {
        let scope = OCSymbolTable(name: name, level: (currentScope?.level ?? 0) + 1, enclosingScope: currentScope)
        scopes[scope.name] = scope
        currentScope = scope
    }
    
    private func popScope() {
        currentScope = currentScope?.enclosingScope
    }
    
    func visit(program: OCProgram) {
        let globalScope = OCSymbolTable(name: "global", level: 1, enclosingScope: nil)

        scopes[globalScope.name] = globalScope
        currentScope = globalScope
        visit(interface: program.interface)
        visit(implementation: program.implementation)
        
        currentScope = nil
    }
    
    func visit(variableDelcaration: OCVariableDeclaration) {
        guard let scope = currentScope else {
            fatalError("Error: out of scope")
        }
        
        guard scope.lookup(variableDelcaration.variable.name,currentScopeOnly: true) == nil else {
            fatalError("Error: Duplicate identifier")
        }
        
        
        guard let symbolType = scope.lookup(variableDelcaration.type) else {
            fatalError("Error: type not found")
        }
        
        scope.define(OCVariableSymbol(name: variableDelcaration.variable.name, type: symbolType ))
        visit(node: variableDelcaration.variable)
        visit(node: variableDelcaration.right)
    }
    
    func visit(method: OCMethod) {
        pushScope(name: method.methodName)
        
        for statement in method.statements {
            visit(node: statement)
        }
        
        popScope()
    }
    
    func visit(propertyDeclaration: OCPropertyDeclaration) {
        guard let scope = currentScope else {
            fatalError("Error: out of a scope")
        }
        
        guard scope.lookup(propertyDeclaration.name) == nil else {
            fatalError("Error: duplicate identifier \(propertyDeclaration.name) found")
        }
        
        guard let symboleType = scope.lookup(propertyDeclaration.type) else {
            fatalError("Error: \(propertyDeclaration.type) type not found")
        }
        
        scope.define(OCVariableSymbol(name: propertyDeclaration.name, type: symboleType))
    }
    
    func visit(variableDeclaration: OCVariableDeclaration) {
        guard let scope = currentScope else {
            fatalError("Error: cannot access")
        }
        
        guard let symboleType = scope.lookup(variableDeclaration.type) else {
            fatalError("Error: canot lookup given type.")
        }
        
        let variableSymbol = OCVariableSymbol(name:variableDeclaration.variable.name,type:symboleType)
        scope.define(variableSymbol)
    }
    
    func visit(variable: OCVar) {
        guard let scope = currentScope else {
            fatalError("Error: cannot access")
        }
        
        guard scope.lookup(variable.name) != nil else {
            fatalError("Error: \(variable.name) variable not found")
        }
    }
}
