//
// Created by Vadim Sergeev on 18.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation
import iosMath
import Darwin

enum CalcSingleAction: CalcAction {
    case oneDivX
    case xPowTwo
    case xPowThree
    case twoSquareRoot
    case threeSquareRoot
    case ePowX
    case tenPowX
    case twoPowX
    case logTen
    case logTwo
    case ln
    case factorial
    case sin(Bool)
    case cos(Bool)
    case tan(Bool)
    case sinInverse(Bool)
    case cosInverse(Bool)
    case tanInverse(Bool)
    case sinh
    case cosh
    case tanh
    case sinhInverse
    case coshInverse
    case tanhInverse
    case onePercent
    case yPercent(Double)

    var mathList: MTMathList {
        var mathAtom: MTMathAtom
        switch self {
        case .xPowTwo:
            return MTMathListBuilder.init(string: "x^{2}").build()!
        case .xPowThree:
            return MTMathListBuilder.init(string: "x^{3}").build()!
        case .ePowX:
            return MTMathListBuilder.init(string: "e^{x}").build()!
        case .tenPowX:
            return MTMathListBuilder.init(string: "10^{x}").build()!
        case .twoPowX:
            return MTMathListBuilder.init(string: "2^{x}").build()!
        case .oneDivX:
            mathAtom = MTMathAtom(type: .placeholder, value: "1/x")
            break
        case .twoSquareRoot:
            return MTMathListBuilder.init(string: "\\sqrt[2]{x}").build()!
        case .threeSquareRoot:
            return MTMathListBuilder.init(string: "\\sqrt[3]{x}").build()!
        case .ln:
            mathAtom = MTMathAtom(type: .placeholder, value: "ln")
            break
        case .logTen:
            return MTMathListBuilder.init(string: "log _{10}").build()!
        case .factorial:
            mathAtom = MTMathAtom(type: .placeholder, value: "x!")
            break
        case .sin:
            mathAtom = MTMathAtom(type: .placeholder, value: "sin")
            break
        case .cos:
            mathAtom = MTMathAtom(type: .placeholder, value: "cos")
            break
        case .sinInverse:
            return MTMathListBuilder.init(string: "sin^{-1}").build()!
        case .cosInverse:
            return MTMathListBuilder.init(string: "cos^{-1}").build()!
        case .tanInverse:
            return MTMathListBuilder.init(string: "tan^{-1}").build()!
        case .tan:
            mathAtom = MTMathAtom(type: .placeholder, value: "tan")
            break
        case .sinh:
            mathAtom = MTMathAtom(type: .placeholder, value: "sinh")
            break
        case .cosh:
            mathAtom = MTMathAtom(type: .placeholder, value: "cosh")
            break
        case .tanh:
            mathAtom = MTMathAtom(type: .placeholder, value: "tanh")
            break
        case .sinhInverse:
            return MTMathListBuilder.init(string: "sinh^{-1}").build()!
        case .coshInverse:
            return MTMathListBuilder.init(string: "cosh^{-1}").build()!
        case .tanhInverse:
            return MTMathListBuilder.init(string: "tanh^{-1}").build()!
        case .logTwo:
            return MTMathListBuilder.init(string: "log _{2}").build()!
        case .onePercent:
            mathAtom = MTMathAtom(type: .placeholder, value: "1%")
            break
        case .yPercent(let value):
            mathAtom = MTMathAtom(type: .placeholder, value: "\(value.stringRepresentation())%")
            break
        }

        let mathList = MTMathList()
        mathList.addAtom(mathAtom)

        return mathList
    }

    func performAction(_ arg: Double) -> Double {
        switch self {
        case .xPowTwo: return pow(arg, 2.0)
        case .xPowThree: return pow(arg, 3.0)
        case .ePowX: return pow(M_E, arg)
        case .tenPowX: return pow(10, arg)
        case .oneDivX: return 1 / arg
        case .twoSquareRoot: return pow(arg, 1.0 / 2.0)
        case .threeSquareRoot: return pow(arg, 1.0 / 3.0)
        case .ln: return log(arg) / log(M_E)
        case .logTen: return log10(arg)
        case .factorial: return Double.fact(n: arg)
        case .sin(let radiansFlag):
            let value = radiansFlag ? arg : arg.degreesToRadians
            return Darwin.sin(value)
        case .cos(let radiansFlag):
            let value = radiansFlag ? arg : arg.degreesToRadians
            return Darwin.cos(value)
        case .tan(let radiansFlag):
            let value = radiansFlag ? arg : arg.degreesToRadians
            return Darwin.tan(value)
        case .sinh: return Darwin.sinh(arg)
        case .cosh: return Darwin.cosh(arg)
        case .tanh: return Darwin.tanh(arg)
                //2nd
        case .twoPowX: return pow(2, arg)
        case .logTwo: return log2(arg)
        case .sinInverse(let radiansFlag):
            let value = radiansFlag ? arg : arg.degreesToRadians
            return asin(value)
        case .cosInverse(let radiansFlag):
            let value = radiansFlag ? arg : arg.degreesToRadians
            return acos(value)
        case .tanInverse(let radiansFlag):
            let value = radiansFlag ? arg : arg.degreesToRadians
            return atan(value)
        case .sinhInverse: return log(arg + sqrt(pow(arg, 2) + 1))
        case .coshInverse: return log(arg + sqrt(pow(arg, 2) - 1))
        case .tanhInverse: return 0.5 * log((1 + arg) / (1 - arg))
        case .onePercent: return arg * 0.01
        case .yPercent(let value):
            return arg / 100 * value
        }
    }

}