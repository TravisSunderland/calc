//
// Created by Vadim Sergeev on 21.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation

public class InfixExpressionBuilder: CustomStringConvertible {

    private var expression = [Token]()

    func addOperator(_ operatorType: CalcCommand) {
        debugPrint("operator added \(operatorType)")
        expression.append(Token(operatorType: operatorType))
    }

    func addOperand(_ operand: OperandToken) {
        debugPrint("operand added \(operand)")
        expression.append(Token(operand: operand))
    }

    func addSingleAction(_ singleAction: CalcSingleAction) {
        expression.append(Token(singleAction: singleAction))
    }

    func addBracket(_ calcBracket: CalcBracket) {
        expression.append(Token(tokenType: .calcBracket(calcBracket)))
    }

    func build() -> [Token] {
        return expression
    }

    public var description: String {
        return self.expression.map({ token -> String in
            return String(describing: token)
        }).joined(separator: " ")
    }

}

