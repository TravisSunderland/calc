//
// Created by Vadim Sergeev on 22.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation
import iosMath

enum CalcConstant: CalcAction {
    case e
    case pi
    case rand
    case memory(Double)

    var value: Double {
        switch self {
        case .e:
            return M_E
        case .pi:
            return Double.pi
        case .rand:
            return Double.random
        case .memory(let value):
            return value
        }
    }

    var mathList: MTMathList {
        var mathAtom: MTMathAtom

        switch self {
        case .pi:
            mathAtom = MTMathAtom(type: .placeholder, value: "π")
            break
        case .rand:
            mathAtom = MTMathAtom(type: .placeholder, value: "Rand")
            break
        case .e:
            mathAtom = MTMathAtom(type: .placeholder, value: "e")
            break
        case .memory(let value):
            mathAtom = MTMathAtom(type: .number, value: value.stringRepresentation())
            break
        }

        let mathList = MTMathList()
        mathList.addAtom(mathAtom)

        return mathList
    }

}