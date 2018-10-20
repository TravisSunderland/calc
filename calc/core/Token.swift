//
// Created by Vadim Sergeev on 21.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation

struct Token: CustomStringConvertible {
    let tokenType: TokenType

    init(tokenType: TokenType) {
        self.tokenType = tokenType
    }

    init(singleAction: CalcSingleAction) {
        tokenType = .singleAction(singleAction)
    }

    init(operand: OperandToken) {
        tokenType = .operand(operand)
    }

    init(operatorType: CalcCommand) {
        tokenType = .mathOperator(OperatorToken(operatorType: operatorType))
    }

    var isOpenBracket: Bool {
        switch tokenType {
        case .calcBracket(let calcBracket):
            switch calcBracket {
            case .leftBracket:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    var isOperator: Bool {
        switch tokenType {
        case .mathOperator(_):
            return true
        default:
            return false
        }
    }

    var operatorToken: OperatorToken? {
        switch tokenType {
        case .mathOperator(let operatorToken):
            return operatorToken
        default:
            return nil
        }
    }

    public var description: String {
        return String(describing: tokenType)
    }
}

enum OperandToken: CustomStringConvertible {
    case numeric(Double)
    case calcConstant(CalcConstant)

    var value: Double {
        switch self {
        case .numeric(let value):
            return value
        case .calcConstant(let calcConstant):
            return calcConstant.value
        }
    }

    var description: String {
        switch self {
        case .numeric(let value):
            return value.stringRepresentation()
        case .calcConstant(let calcConstant):
            return String.init(describing: calcConstant)
        }
    }

}

struct BracketToken: CustomStringConvertible {
    let calcBracket: CalcBracket

    init(_ calcBracket: CalcBracket) {
        self.calcBracket = calcBracket
    }

    var description: String {
        return String(describing: self.calcBracket)
    }
}

struct OperatorToken: CustomStringConvertible {
    let operatorType: CalcCommand

    init(operatorType: CalcCommand) {
        self.operatorType = operatorType
    }

    var precedence: Int {
        switch operatorType {
        case .add,
             .subtract:
            return 0
        case .divide,
             .multiply:
            return 5
        case .xPowY,
             .yPowX,
             .xyRoot,
             .EE,
             .logY:
            return 10
        }
    }

    var associativity: OperatorAssociativity {
        switch operatorType {
        case .add,
             .subtract,
             .divide,
             .multiply:
            return .leftAssociative
        case .xPowY,
             .yPowX,
             .xyRoot,
             .EE,
             .logY:
            return .rightAssociative
        }
    }

    public var description: String {
        return String(describing: operatorType)
    }

    static func <=(left: OperatorToken, right: OperatorToken) -> Bool {
        return left.precedence <= right.precedence
    }

    static func <(left: OperatorToken, right: OperatorToken) -> Bool {
        return left.precedence < right.precedence
    }

}

internal enum OperatorAssociativity {
    case leftAssociative
    case rightAssociative
}

enum TokenType: CustomStringConvertible {
    case calcBracket(CalcBracket)
    case mathOperator(OperatorToken)
    case operand(OperandToken)
    case singleAction(CalcSingleAction)

    public var description: String {
        switch self {
        case .calcBracket(let calcBracket):
            return String(describing: calcBracket)
        case .mathOperator(let operatorToken):
            return String(describing: operatorToken)
        case .operand(let value):
            return String(describing: value)
        case .singleAction(let singleAction):
            return String(describing: singleAction)
        }
    }
}