//
// Created by Vadim Sergeev on 21.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation

class PolishExpressionBuilder {

    private static var _sharedInstance: PolishExpressionBuilder!

    private var reloadingNavigationStack = false
    private var needToReloadNavigationStackAgain = false

    static var sharedInstance: PolishExpressionBuilder {
        if (_sharedInstance == nil) {
            _sharedInstance = PolishExpressionBuilder()
        }

        return _sharedInstance
    }

    private init() {
    }

    func calculatePolish(_ infixExpression: Array<Token>) throws -> Double {
        let polishExpression = try self.reversePolishNotation(infixExpression)
        var stack = Stack<Double>()

        debugPrint("polish before result: \(String(describing: polishExpression))")

        try polishExpression.forEach { (token: Token) in
            switch token.tokenType {
            case .operand(let operand):
                stack.push(operand.value)
                break
            case .mathOperator(let operatorToken):
                let arg2 = try stack.pop()
                let arg1 = try stack.pop()
                let result = operatorToken.operatorType.performOperation(arg1: arg1, arg2: arg2)
                stack.push(result)
                break
            case .singleAction(let singleAction):
                var arg: Double
                switch singleAction {
                case .yPercent:
                    arg = stack.peek()
                    break
                default:
                    arg = try stack.pop()
                    break
                }
                let result = singleAction.performAction(arg)
                stack.push(result)
                break
            default:
                let expressionStr = self.expressionFromInfix(infixExpression)
                throw StudyflowError.calcExpressionError(expression: expressionStr)
            }
        }

        guard let result = stack.popLast(),
              stack.count == 0 else {
            let expressionStr = self.expressionFromInfix(infixExpression)
            throw StudyflowError.calcExpressionError(expression: expressionStr)
        }

        return result
    }

    private func expressionFromInfix(_ infixExpression: [Token]) -> String {
        return infixExpression.map { token -> String in
            return token.description
        }.reduce("") { (result: String, value: String) -> String in
            return "\(result)\(value)"
        }
    }

    // This returns the result of the shunting yard algorithm
    func reversePolishNotation(_ expression: [Token]) throws -> [Token] {
        var tokenStack = Stack<Token>()
        var reversePolishNotation = [Token]()

        for token in expression {
            switch token.tokenType {
            case .operand(_):
                reversePolishNotation.append(token)
                break
            case .singleAction:
                reversePolishNotation.append(token)
                break
            case .calcBracket(let calcBracket):
                switch calcBracket {
                case .leftBracket:
                    tokenStack.push(token)
                    break
                case .rightBracket:
                    while (tokenStack.count > 0) {
                        let tempToken = try tokenStack.pop()
                        if (tempToken.isOpenBracket == false) {
                            reversePolishNotation.append(tempToken)
                        } else {
                            break
                        }
                    }
                    break
                }
                break
            case .mathOperator(let operatorToken):
                for tempToken in tokenStack.makeIterator() {
                    if !tempToken.isOperator {
                        break
                    }

                    if let tempOperatorToken = tempToken.operatorToken {
                        if operatorToken.associativity == .leftAssociative && operatorToken <= tempOperatorToken
                                   || operatorToken.associativity == .rightAssociative && operatorToken < tempOperatorToken {
                            reversePolishNotation.append(try tokenStack.pop())
                        } else {
                            break
                        }
                    }
                }
                tokenStack.push(token)
                break
            }

            debugPrint("rpn: \(String(describing: reversePolishNotation))")
            debugPrint("stack rpn: \(String(describing: tokenStack))")
        }

        while tokenStack.count > 0 {
            reversePolishNotation.append(try tokenStack.pop())
        }

        return reversePolishNotation
    }

}