//
// Created by Vadim Sergeev on 21.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation

class CalcBrain {

    let delegate: CalcBrainDelegate

    var radiansFlag: Bool = false

    let infixExpressionBuilder = InfixExpressionBuilder()

    init(delegate: CalcBrainDelegate) {
        self.delegate = delegate
    }

    func handleNewNumberEntered(_ operand: OperandToken) {
        self.infixExpressionBuilder.addOperand(operand)
        self.updateInfixRepresentation()
    }

    func handleSingleAction(_ singleAction: CalcSingleAction) throws {
        self.infixExpressionBuilder.addSingleAction(singleAction)
        self.updateInfixRepresentation()
        try self.calculateSingleAction()
    }

    private func calculateSingleAction() throws {
        let infixTokens = self.infixExpressionBuilder.build()
        debugPrint("infix: \(infixTokens)")
        let polishTokens = try PolishExpressionBuilder.sharedInstance.reversePolishNotation(infixTokens)
        debugPrint("polish: \(polishTokens)")
        let result = try PolishExpressionBuilder.sharedInstance.calculatePolish(infixTokens)
        debugPrint("result: \(result)")
        self.updateDisplayResult(result)
    }

    func calculateTotal() throws {
        let infixTokens = self.infixExpressionBuilder.build()
        debugPrint("infix: \(infixTokens)")
        let polishTokens = try PolishExpressionBuilder.sharedInstance.reversePolishNotation(infixTokens)
        debugPrint("polish: \(polishTokens)")
        let result = try PolishExpressionBuilder.sharedInstance.calculatePolish(infixTokens)
        debugPrint("result: \(result)")
        self.updateDisplayResult(result)
    }

    func handleNewBracket(_ bracket: CalcBracket) {
        self.infixExpressionBuilder.addBracket(bracket)
        self.updateInfixRepresentation()
    }

    func handleNewCommand(_ command: CalcCommand) {
        self.infixExpressionBuilder.addOperator(command)
        self.updateInfixRepresentation()
    }

    private func updateInfixRepresentation() {
        self.delegate.updateInfixExpression(self.infixExpressionBuilder.build())
    }

    private func updateDisplayResult(_ result: Double) {
        self.delegate.updateDisplayResult(result)
    }

}

protocol CalcBrainDelegate {

    func updateInfixExpression(_ expression: Array<Token>)

    func updateDisplayResult(_ result: Double)

}