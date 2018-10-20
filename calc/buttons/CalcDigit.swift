//
// Created by Vadim Sergeev on 17.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation
import iosMath

enum CalcDigit: CalcAction {
    case d_0
    case d_1
    case d_2
    case d_3
    case d_4
    case d_5
    case d_6
    case d_7
    case d_8
    case d_9
    case dot

    static func valueOfChar(_ char: Character) throws -> CalcDigit {
        switch char {
        case "0":
            return d_0
        case "1":
            return d_1
        case "2":
            return d_2
        case "3":
            return d_3
        case "4":
            return d_4
        case "5":
            return d_5
        case "6":
            return d_6
        case "7":
            return d_7
        case "8":
            return d_8
        case "9":
            return d_9
        case ".":
            return dot
        case ",":
            return dot
        default:
            throw StudyflowError.invalidCalcChar(char: char)
        }
    }

    var value: String {
        switch self {
        case .d_0:
            return "0"
        case .d_1:
            return "1"
        case .d_2:
            return "2"
        case .d_3:
            return "3"
        case .d_4:
            return "4"
        case .d_5:
            return "5"
        case .d_6:
            return "6"
        case .d_7:
            return "7"
        case .d_8:
            return "8"
        case .d_9:
            return "9"
        case .dot:
            return NSLocale.current.decimalSeparator ?? ","
        }
    }

    var mathList: MTMathList {
        let mathAtom = MTMathAtom(type: .number, value: self.value)

        let mathList = MTMathList()
        mathList.addAtom(mathAtom)

        return mathList
    }

}