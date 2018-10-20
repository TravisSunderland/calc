//
// Created by Vadim Sergeev on 17.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation
import iosMath

enum CalcCommand: CalcAction {
    case divide
    case multiply
    case add
    case subtract
    case xPowY
    case xyRoot
    case EE
    case yPowX
    case logY

    var isBase: Bool {
        switch self {
        case CalcCommand.divide,
             CalcCommand.multiply,
             CalcCommand.add,
             CalcCommand.subtract:
            return true
        default:
            return false
        }
    }

    var mathList: MTMathList {
        var mathAtom: MTMathAtom

        switch self {
        case .divide:
            mathAtom = MTMathAtom(type: .placeholder, value: "÷")
            break
        case .multiply:
            mathAtom = MTMathAtom(type: .placeholder, value: "×")
            break
        case .add:
            mathAtom = MTMathAtom(type: .placeholder, value: "+")
            break
        case .subtract:
            mathAtom = MTMathAtom(type: .placeholder, value: "-")
            break
        case .xPowY:
            return MTMathListBuilder.init(string: "x^{y}").build()!
        case .xyRoot:
            return MTMathListBuilder.init(string: "\\sqrt[y]{x}").build()!
        case .EE:
            mathAtom = MTMathAtom(type: .placeholder, value: "EE")
            break
        case .logY:
            return MTMathListBuilder.init(string: "log _{y}").build()!
        case .yPowX:
            return MTMathListBuilder.init(string: "y^{x}").build()!
        }

        let mathList = MTMathList()
        mathList.addAtom(mathAtom)

        return mathList
    }

    func performOperation(arg1: Double, arg2: Double) -> Double {
        switch self {
        case .add:
            return arg1 + arg2
        case .subtract:
            return arg1 - arg2
        case .divide:
            return arg1 / arg2
        case .multiply:
            return arg1 * arg2
        case .xPowY:
            return Darwin.pow(arg1, arg2)
        case .xyRoot:
            return Darwin.pow(arg1, 1 / arg2)
        case .logY:
            return Darwin.log(arg2) / Darwin.log(arg1)
        case .EE:
            return arg1 * Darwin.pow(10.0, arg2)
        case .yPowX:
            return Darwin.pow(arg2, arg1)
        }
    }

}