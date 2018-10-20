//
// Created by Vadim Sergeev on 17.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation

extension CalcViewController {

    func configureButtons() {
        let extraFirstSubviews = self.extraStackView1.arrangedSubviews
        (0..<extraFirstSubviews.count).forEach { i in
            guard let calcButton = extraFirstSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.calcBracket(.leftBracket), customDelegate: self)
                break
            case 1:
                calcButton.configure(.calcBracket(.rightBracket), customDelegate: self)
                break
            case 2:
                calcButton.configure(.calcExtra(.memoryClear), customDelegate: self)
                break
            case 3:
                calcButton.configure(.calcExtra(.memoryAdd), customDelegate: self)
                break
            case 4:
                calcButton.configure(.calcExtra(.memorySubtract), customDelegate: self)
                break
            case 5:
                calcButton.configure(.calcExtra(.memoryRecall), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for extraFirstSubviews \(i)")
                break
            }
        }

        let extraSecondSubviews = self.extraStackView2.arrangedSubviews
        (0..<extraSecondSubviews.count).forEach { i in
            guard let calcButton = extraSecondSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.calcExtra(.second), customDelegate: self)
                break
            case 1:
                calcButton.configure(.singleAction(.xPowTwo), customDelegate: self)
                break
            case 2:
                calcButton.configure(.singleAction(.xPowThree), customDelegate: self)
                break
            case 3:
                calcButton.configure(.calcCommand(.xPowY), customDelegate: self)
                break
            case 4:
                if (self.twoNdEnabled) {
                    calcButton.configure(.calcCommand(.yPowX), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.ePowX), customDelegate: self)
                }
                break
            case 5:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.twoPowX), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.tenPowX), customDelegate: self)
                }
                break
            default:
                debugPrint("unsupported button index for extraSecondSubviews \(i)")
                break
            }
        }

        let extraThirdSubviews = self.extraStackView3.arrangedSubviews
        (0..<extraThirdSubviews.count).forEach { i in
            guard let calcButton = extraThirdSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.singleAction(.oneDivX), customDelegate: self)
                break
            case 1:
                calcButton.configure(.singleAction(.twoSquareRoot), customDelegate: self)
                break
            case 2:
                calcButton.configure(.singleAction(.threeSquareRoot), customDelegate: self)
                break
            case 3:
                calcButton.configure(.calcCommand(.xyRoot), customDelegate: self)
                break
            case 4:
                if (self.twoNdEnabled) {
                    calcButton.configure(.calcCommand(.logY), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.ln), customDelegate: self)
                }
                break
            case 5:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.logTwo), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.logTen), customDelegate: self)
                }
                break
            default:
                debugPrint("unsupported button index for extraThirdSubviews \(i)")
                break
            }
        }

        let extraFourthSubviews = self.extraStackView4.arrangedSubviews
        (0..<extraFourthSubviews.count).forEach { i in
            guard let calcButton = extraFourthSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.singleAction(.factorial), customDelegate: self)
                break
            case 1:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.sinInverse(self.radiansFlag)), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.sin(self.radiansFlag)), customDelegate: self)
                }
                break
            case 2:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.cosInverse(self.radiansFlag)), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.cos(self.radiansFlag)), customDelegate: self)
                }
                break
            case 3:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.tanInverse(self.radiansFlag)), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.tan(self.radiansFlag)), customDelegate: self)
                }
                break
            case 4:
                calcButton.configure(.calcConstant(.e), customDelegate: self)
                break
            case 5:
                calcButton.configure(.calcCommand(.EE), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for extraFourthSubviews \(i)")
                break
            }
        }

        let extraFifthsSubviews = self.extraStackView5.arrangedSubviews
        (0..<extraFifthsSubviews.count).forEach { i in
            guard let calcButton = extraFifthsSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                if (self.radiansFlag) {
                    calcButton.configure(.calcExtra(.Deg), customDelegate: self)
                } else {
                    calcButton.configure(.calcExtra(.Rad), customDelegate: self)
                }
                break
            case 1:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.sinhInverse), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.sinh), customDelegate: self)
                }
                break
            case 2:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.coshInverse), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.cosh), customDelegate: self)
                }
                break
            case 3:
                if (self.twoNdEnabled) {
                    calcButton.configure(.singleAction(.tanhInverse), customDelegate: self)
                } else {
                    calcButton.configure(.singleAction(.tanh), customDelegate: self)
                }
                break
            case 4:
                calcButton.configure(.calcConstant(.pi), customDelegate: self)
                break
            case 5:
                calcButton.configure(.calcConstant(.rand), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for extraFifthsSubviews \(i)")
                break
            }
        }

        let baseFirstSubviews = self.baseStackView1.arrangedSubviews
        (0..<baseFirstSubviews.count).forEach { i in
            guard let calcButton = baseFirstSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                if (self.calcSessionState == .activated) {
                    calcButton.configure(.calcExtra(.clear), customDelegate: self)
                } else {
                    calcButton.configure(.calcExtra(.allClear), customDelegate: self)
                }
                break
            case 1:
                calcButton.configure(.calcExtra(.signChange), customDelegate: self)
                break
            case 2:
                calcButton.configure(.calcExtra(.percentExtra), customDelegate: self)
                break
            case 3:
                calcButton.configure(.calcCommand(.divide), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for baseFirstSubviews \(i)")
                break
            }
        }

        let baseSecondSubviews = self.baseStackView2.arrangedSubviews
        (0..<baseSecondSubviews.count).forEach { i in
            guard let calcButton = baseSecondSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.digit(.d_7), customDelegate: self)
                break
            case 1:
                calcButton.configure(.digit(.d_8), customDelegate: self)
                break
            case 2:
                calcButton.configure(.digit(.d_9), customDelegate: self)
                break
            case 3:
                calcButton.configure(.calcCommand(.multiply), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for baseSecondSubviews \(i)")
                break
            }
        }

        let baseThirdSubviews = self.baseStackView3.arrangedSubviews
        (0..<baseThirdSubviews.count).forEach { i in
            guard let calcButton = baseThirdSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.digit(.d_4), customDelegate: self)
                break
            case 1:
                calcButton.configure(.digit(.d_5), customDelegate: self)
                break
            case 2:
                calcButton.configure(.digit(.d_6), customDelegate: self)
                break
            case 3:
                calcButton.configure(.calcCommand(.subtract), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for baseThirdSubviews \(i)")
                break
            }
        }

        let baseFourthSubviews = self.baseStackView4.arrangedSubviews
        (0..<baseFourthSubviews.count).forEach { i in
            guard let calcButton = baseFourthSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.digit(.d_1), customDelegate: self)
                break
            case 1:
                calcButton.configure(.digit(.d_2), customDelegate: self)
                break
            case 2:
                calcButton.configure(.digit(.d_3), customDelegate: self)
                break
            case 3:
                calcButton.configure(.calcCommand(.add), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for baseFourthSubviews \(i)")
                break
            }
        }

        let baseFifthSubviews = self.baseStackView5.arrangedSubviews
        (0..<baseFifthSubviews.count).forEach { i in
            guard let calcButton = baseFifthSubviews[i] as? CustomCalcButton else {
                return
            }

            switch i {
            case 0:
                calcButton.configure(.digit(.d_0), customDelegate: self)
                break
            case 1:
                calcButton.configure(.digit(.dot), customDelegate: self)
                break
            case 2:
                calcButton.configure(.calcExtra(.equals), customDelegate: self)
                break
            default:
                debugPrint("unsupported button index for baseFifthSubviews \(i)")
                break
            }
        }
    }

}