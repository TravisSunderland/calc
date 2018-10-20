//
// Created by Vadim Sergeev on 24.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation
import iosMath

enum CalcBracket: CalcAction {
    case leftBracket
    case rightBracket

    var mathList: MTMathList {
        var mathAtom: MTMathAtom
        switch self {
        case .leftBracket:
            mathAtom = MTMathAtom(type: .placeholder, value: "(")
            break
        case .rightBracket:
            mathAtom = MTMathAtom(type: .placeholder, value: ")")
            break
        }
        let mathList = MTMathList()
        mathList.addAtom(mathAtom)

        return mathList
    }

}