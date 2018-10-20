//
// Created by Vadim Sergeev on 17.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation
import iosMath

enum CalcExtra: CalcAction {
    case memoryClear
    case memoryAdd
    case memorySubtract
    case memoryRecall
    case allClear
    case clear
    case second
    case equals
    case Rad
    case Deg
    case signChange
    case percentExtra

    var mathList: MTMathList {
        var mathAtom: MTMathAtom

        switch self {
        case .memoryClear:
            mathAtom = MTMathAtom(type: .placeholder, value: "mc")
            break
        case .memoryAdd:
            mathAtom = MTMathAtom(type: .placeholder, value: "m+")
            break
        case .memorySubtract:
            mathAtom = MTMathAtom(type: .placeholder, value: "m-")
            break
        case .memoryRecall:
            mathAtom = MTMathAtom(type: .placeholder, value: "mr")
            break
        case .allClear:
            mathAtom = MTMathAtom(type: .placeholder, value: "AC")
            break
        case .clear:
            mathAtom = MTMathAtom(type: .placeholder, value: "C")
            break
        case .second:
            return MTMathListBuilder.init(string: "2^{nd}").build()!
        case .equals:
            mathAtom = MTMathAtom(type: .placeholder, value: "=")
            break
        case .Rad:
            mathAtom = MTMathAtom(type: .placeholder, value: "Rad")
            break
        case .Deg:
            mathAtom = MTMathAtom(type: .placeholder, value: "Deg")
            break
        case .signChange:
            mathAtom = MTMathAtom(type: .placeholder, value: "+/-")
            break
        case .percentExtra:
            mathAtom = MTMathAtom(type: .placeholder, value: "%")
            break
        }

        let mathList = MTMathList()
        mathList.addAtom(mathAtom)

        return mathList
    }

}