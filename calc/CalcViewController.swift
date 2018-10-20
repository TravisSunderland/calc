//
//  CalcViewController.swift
//  Studyflow
//
//  Created by Vadim Sergeev on 07.01.18.
//  Copyright © 2018 studyflow. All rights reserved.
//

import UIKit
import iosMath

class CalcViewController: CustomViewController {

    @IBOutlet weak var displayLabel: CopyableLabel!
    @IBOutlet weak var expressionLabelContainer: UIView!
    private var expressionLabel: MTMathUILabel!
    @IBOutlet weak var displayLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var radLabel: CustomLabel!
    @IBOutlet weak var memoryLabel: CustomLabel!

    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet var extraStackView1: UIStackView!
    @IBOutlet var baseStackView1: UIStackView!

    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet var extraStackView2: UIStackView!
    @IBOutlet var baseStackView2: UIStackView!

    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet var extraStackView3: UIStackView!
    @IBOutlet var baseStackView3: UIStackView!

    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet var extraStackView4: UIStackView!
    @IBOutlet var baseStackView4: UIStackView!

    @IBOutlet weak var stackView5: UIStackView!
    @IBOutlet var extraStackView5: UIStackView!
    @IBOutlet var baseStackView5: UIStackView!

    @IBOutlet internal var stackViewsWithButtons: [UIStackView]!

    private var pressedDigits: PressedDigits?
    private var pressedCalcConstant: CalcConstant?
    private var pressedCommand: CalcCommand?
    private var pressedSingleAction: CalcSingleAction?
    private var pressedBracket: CalcBracket?

    private var calcBrain: CalcBrain!

    var currentOrientation: UIDeviceOrientation = .portrait

    var twoNdEnabled: Bool = false
    var radiansFlag: Bool = false

    private var lastResult: Double?
    private var lastCommand: CalcCommand?
    private var lastSingleAction: CalcSingleAction?
    private var lastOperand: OperandToken?

    private var expression: Array<Token>?
    private var tmpMathList: MTMathList?

    private var memoryValue: Double?

    var calcSessionState: CalcSessionState = .ended {
        didSet {
            self.handleCalcSessionChanged()
        }
    }

    private func handleCalcSessionChanged() {
        switch self.calcSessionState {
        case .activated:
            self.lastResult = nil
            self.lastCommand = nil
            self.lastSingleAction = nil
            self.lastOperand = nil
            break
        case .cleared:
            self.tmpMathList = nil

            self.pressedDigits = nil
            self.pressedCalcConstant = nil
            self.pressedCommand = nil
            self.pressedSingleAction = nil
            self.pressedBracket = nil
            break
        case .ended:
            self.calcBrain = CalcBrain(delegate: self)
            break
        }

        self.configureButtons()
        self.updateOutput()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.supportsLandscape = true

        self.displayLabel.delegate = self

        self.addExpressionLabel()

        self.updateUI(twoNdEnabled: self.twoNdEnabled, radiansFlag: self.radiansFlag)

        let toLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        self.switchToOrientation(toLandscape: toLandscape)

        self.allClear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.currentOrientation != UIDevice.current.orientation {
            let toLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
            self.switchToOrientation(toLandscape: toLandscape)
        }
    }

    private func addExpressionLabel() {
        self.expressionLabel = MTMathUILabel()
        self.expressionLabel.textAlignment = .right
        self.expressionLabel.textColor = UIColor.white

        self.expressionLabelContainer.addContentView(self.expressionLabel, horizontalPadding: 10)
        self.expressionLabelContainer.translatesAutoresizingMaskIntoConstraints = false

        let height = NSLayoutConstraint(item: self.expressionLabel,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: 30)

        self.expressionLabel.addConstraint(height)
    }

    private func updateUI(twoNdEnabled: Bool, radiansFlag: Bool) {
        self.twoNdEnabled = twoNdEnabled
        self.radiansFlag = radiansFlag

        self.configureButtons()
        self.radLabel.isHidden = !radiansFlag
    }

    private func allClear() {
        self.calcBrain = CalcBrain(delegate: self)

        self.memoryValue = nil
        self.updateMemoryLabelVisibility()

        self.clear()
    }

    private func updateMemoryLabelVisibility() {
        self.memoryLabel.isHidden = self.memoryValue == nil
    }

    private func clear() {
        self.pressedDigits = nil
        self.pressedCalcConstant = nil
        self.pressedCommand = nil
        self.pressedSingleAction = nil
        self.pressedBracket = nil

        self.lastResult = nil
        self.lastOperand = nil

        self.tmpMathList = nil
        self.expression = nil

        self.deselectAllButtons()

        self.updateOutput()
    }

    func handleDigitTap(_ digit: CalcDigit) {
        self.reactivateSessionIfNeeded()

        self.pressedCalcConstant = nil

        guard let pressedDigits = self.pressedDigits else {
            self.commitPreviousOperations(currentOperation: digit)

            if (self.checkOperationCouldBeAdded(digit)) {
                self.pressedDigits = PressedDigits(digit)
            }

            return
        }

        if (self.checkOperationCouldBeAdded(digit)) {
            pressedDigits.add(digit)
        }
    }

    private func reactivateSessionIfNeeded() {
        if (self.calcSessionState == .ended) {
            self.calcSessionState = .activated
            self.lastResult = nil
            self.expression = nil
            self.updateExpressionOutput()
        }

        if (self.calcSessionState == .cleared) {
            self.calcSessionState = .activated
            self.lastResult = nil
            self.updateExpressionOutput()
        }
    }

    func handleSingleActionTap(_ singleAction: CalcSingleAction) {
        self.resetLastResultIfNeeded()

        self.commitPreviousOperations(currentOperation: singleAction)

        if self.calcBrain.infixExpressionBuilder.build().isEmpty {
            if let valueStr = self.displayLabel.text,
               let value = Double.fromString(valueStr) {
                self.calcBrain.handleNewNumberEntered(.numeric(value))
            }
        }

        if (self.checkOperationCouldBeAdded(singleAction)) {
            self.pressedSingleAction = singleAction
            self.commitPreviousOperations(currentOperation: singleAction)
        }
    }

    func handleCalcBracketTap(_ calcBracket: CalcBracket) {
        self.reactivateSessionIfNeeded()

        self.commitPreviousOperations(currentOperation: calcBracket)

        if (self.checkOperationCouldBeAdded(calcBracket)) {
            self.pressedBracket = calcBracket
            self.commitPreviousOperations(currentOperation: calcBracket)
        }
    }

    func handleCommandTap(_ command: CalcCommand) {
        self.resetLastResultIfNeeded()

        self.commitPreviousOperations(currentOperation: command)

        if self.calcBrain.infixExpressionBuilder.build().isEmpty {
            if let valueStr = self.displayLabel.text,
               let value = Double.fromString(valueStr) {
                self.calcBrain.handleNewNumberEntered(.numeric(value))
            }
        }

        if (self.checkOperationCouldBeAdded(command)) {
            self.pressedCommand = command
        } else {
            self.tmpMathList = nil
        }
    }

    func handleCalcConstantTap(_ calcConstant: CalcConstant) {
        self.resetLastResultIfNeeded()

        self.pressedDigits = nil
        self.pressedCalcConstant = nil

        self.commitPreviousOperations(currentOperation: calcConstant)

        if (self.checkOperationCouldBeAdded(calcConstant)) {
            self.pressedCalcConstant = calcConstant
        } else {
            self.tmpMathList = nil
        }
    }

    func handleCalcExtraTap(_ calcExtra: CalcExtra) {
        switch calcExtra {
        case .equals:
            self.commitPreviousOperations(currentOperation: calcExtra)
            do {
                try self.calcBrain.calculateTotal()
                if let lastResult = lastResult {
                    let mathList = MTMathList()
                    mathList.addAtom(MTMathAtom(type: .placeholder, value: " = "))
                    mathList.append(lastResult.mathList)

                    mathList.atoms.forEach { atom in
                        atom.fontStyle = .roman
                    }

                    self.tmpMathList = mathList
                }
                self.calcSessionState = .ended
            } catch StudyflowError.calcExpressionError {
                self.displayLabel.text = NSLocalizedString("calc_invalidMathExpression", comment: "Invalid math expression")
                self.updateExpressionOutput()
            } catch {
                debugPrint("error on equals: \(String(describing: error))")
                self.displayLabel.text = NSLocalizedString("calc_unknownError", comment: "Unknown error")
            }
            break
        case .allClear:
            self.allClear()
            break
        case .clear:
            self.calcSessionState = .cleared
            break
        case .Rad:
            self.updateUI(twoNdEnabled: self.twoNdEnabled, radiansFlag: true)
            break
        case .Deg:
            self.updateUI(twoNdEnabled: self.twoNdEnabled, radiansFlag: false)
            break
        case .second:
            self.updateUI(twoNdEnabled: !self.twoNdEnabled, radiansFlag: self.radiansFlag)
            break
        case .signChange:
            if let pressedDigits = self.pressedDigits {
                pressedDigits.isNegative = !pressedDigits.isNegative
                self.tmpMathList = pressedDigits.mathList
                self.updateResultOutput()
                self.updateExpressionOutput()
            }
            break
        case .percentExtra:
            self.handlePercentExtra()
            break
        case .memoryAdd:
            self.handleMemoryAdd()
            break
        case .memorySubtract:
            self.handleMemorySubtract()
            break
        case .memoryRecall:
            self.handleMemoryRecall()
            break
        case .memoryClear:
            self.memoryValue = nil
            self.updateMemoryLabelVisibility()
            break
        }
    }

    private func handleMemoryRecall() {
        let value: Double = self.memoryValue ?? 0
        let memoryConstant = CalcConstant.memory(value)
        self.tmpMathList = memoryConstant.mathList
        self.handleCalcConstantTap(memoryConstant)
    }

    private func handleMemoryAdd() {
        guard let currentStrValue = self.displayLabel.text,
              let currentValue = Double.fromString(currentStrValue) else {
            return
        }

        if let currentMemory = self.memoryValue {
            self.memoryValue = currentMemory + currentValue
        } else {
            self.memoryValue = currentValue
        }

        self.updateMemoryLabelVisibility()
    }

    private func handleMemorySubtract() {
        guard let currentStrValue = self.displayLabel.text,
              let currentValue = Double.fromString(currentStrValue) else {
            return
        }

        if let currentMemory = self.memoryValue {
            self.memoryValue = currentMemory - currentValue
        } else {
            self.memoryValue = 0 - currentValue
        }

        self.updateMemoryLabelVisibility()
    }

    private func handlePercentExtra() {
        switch self.calcBrain.infixExpressionBuilder.build().count {
        case 0:
            self.resetLastResultIfNeeded()
            self.commitPreviousOperations(currentOperation: CalcSingleAction.onePercent)

            if (self.calcBrain.infixExpressionBuilder.build().count == 0) {
                if let valueStr = self.displayLabel.text,
                   let value = Double.fromString(valueStr) {
                    self.calcBrain.handleNewNumberEntered(.numeric(value))
                } else {
                    return
                }
            }

            self.pressedSingleAction = CalcSingleAction.onePercent
            self.commitPreviousOperations(currentOperation: CalcSingleAction.onePercent)

            break
        default:
            var optionalValue = self.pressedDigits?.value

            if (optionalValue == nil) {
                optionalValue = self.pressedCalcConstant?.value
            }

            guard let value = optionalValue else {
                return
            }

            self.pressedCalcConstant = nil
            self.pressedDigits = nil

            self.handleSingleActionTap(CalcSingleAction.yPercent(value))
        }
    }

    private func checkOperationCouldBeAdded(_ action: CalcAction) -> Bool {
        switch action {
        case is CalcSingleAction:
            guard let previousOperation = self.calcBrain.infixExpressionBuilder.build().last else {
                return false
            }
            switch previousOperation.tokenType {
            case .operand,
                 .singleAction:
                return true
            case .calcBracket,
                 .mathOperator:
                return false
            }
        case is CalcDigit,
             is CalcConstant:
            guard let previousOperation = self.calcBrain.infixExpressionBuilder.build().last else {
                return true
            }
            switch previousOperation.tokenType {
            case .singleAction,
                 .operand:
                return false
            case .mathOperator:
                return true
            case .calcBracket(let bracket):
                switch bracket {
                case .leftBracket:
                    return true
                case .rightBracket:
                    return false
                }
            }
        case is CalcCommand:
            guard let previousOperation = self.calcBrain.infixExpressionBuilder.build().last else {
                return false
            }
            switch previousOperation.tokenType {
            case .singleAction,
                 .operand:
                return true
            case .mathOperator:
                return false
            case .calcBracket(let bracket):
                switch bracket {
                case .leftBracket:
                    return false
                case .rightBracket:
                    return true
                }
            }
        case is CalcExtra:
            return true
        case is CalcBracket:
            guard let bracket = action as? CalcBracket else {
                return false
            }

            switch bracket {
            case .leftBracket:
                guard let previousOperation = self.calcBrain.infixExpressionBuilder.build().last else {
                    return true
                }
                switch previousOperation.tokenType {
                case .mathOperator:
                    return true
                case .operand,
                     .singleAction:
                    return false
                case .calcBracket(let previousBracket):
                    switch previousBracket {
                    case .leftBracket:
                        return true
                    case .rightBracket:
                        return false
                    }
                }
            case .rightBracket:
                guard let previousOperation = self.calcBrain.infixExpressionBuilder.build().last else {
                    return false
                }
                switch previousOperation.tokenType {
                case .mathOperator:
                    return false
                case .operand,
                     .singleAction:
                    return true
                case .calcBracket(let previousBracket):
                    switch previousBracket {
                    case .leftBracket:
                        return false
                    case .rightBracket:
                        return true
                    }
                }
            }
        default:
            debugPrint("cant validate action: \(String(describing: action))")
            self.displayLabel.text = "invalid \(action.mathList.stringValue)"
            return false
        }
    }

    private func resetLastResultIfNeeded() {
        if (self.calcSessionState == .ended) {
            if let lastResult = self.lastResult {
                self.calcSessionState = .activated
                self.calcBrain.handleNewNumberEntered(.numeric(lastResult))
            } else {
                self.calcSessionState = .activated
            }
        }
    }

    private func commitPreviousOperations(currentOperation: CalcAction) {
        if let lastResult = self.lastResult,
           self.calcSessionState == .ended {
            self.repeatPreviousAction(lastResult: lastResult)
            return
        }

        if let bracket = self.pressedBracket {
            self.calcBrain.handleNewBracket(bracket)
            self.pressedBracket = nil
        }

        if let command = self.pressedCommand {
            let currentCommand = currentOperation as? CalcCommand

            if (currentCommand == nil) {
                self.calcBrain.handleNewCommand(command)
                self.lastCommand = command
                self.pressedCommand = nil
            }
        }

        if let singleAction = self.pressedSingleAction {
            do {
                try self.calcBrain.handleSingleAction(singleAction)
                self.lastSingleAction = singleAction
                self.pressedSingleAction = nil
            } catch StudyflowError.calcExpressionError {
                self.displayLabel.text = NSLocalizedString("calc_invalidMathExpression", comment: "Invalid math expression")
                self.updateExpressionOutput()
                self.pressedSingleAction = nil
            } catch {
                debugPrint("error on single action: \(String(describing: error))")
                self.displayLabel.text = NSLocalizedString("calc_unknownError", comment: "Unknown error")
                self.pressedSingleAction = nil
            }
        }

        if let digits = self.pressedDigits {
            let value = digits.value
            let operand = OperandToken.numeric(value)
            self.calcBrain.handleNewNumberEntered(operand)
            self.lastOperand = operand
            self.pressedDigits = nil
        }

        if let calcConstant = self.pressedCalcConstant {
            let operand = OperandToken.calcConstant(calcConstant)
            self.calcBrain.handleNewNumberEntered(operand)
            self.lastOperand = operand
            self.pressedCalcConstant = nil
        }

        self.updateOutput()
    }

    private func repeatPreviousAction(lastResult: Double) {
        self.calcBrain.handleNewNumberEntered(.numeric(lastResult))

        if let lastSingleAction = self.lastSingleAction {
            do {
                try self.calcBrain.handleSingleAction(lastSingleAction)
                self.lastSingleAction = lastSingleAction
            } catch StudyflowError.calcExpressionError {
                self.displayLabel.text = NSLocalizedString("calc_invalidMathExpression", comment: "Invalid math expression")
                self.updateExpressionOutput()
                return
            } catch {
                debugPrint("error on repeat previous single action action: \(String(describing: error))")
                return
            }
        }

        if let lastCommand = self.lastCommand,
           let lastOperand = self.lastOperand {
            self.calcBrain.handleNewCommand(lastCommand)
            self.calcBrain.handleNewNumberEntered(lastOperand)

            self.lastCommand = lastCommand
            self.lastOperand = lastOperand
        }
    }

    private func updateOutput() {
        self.updateResultOutput()
        self.updateExpressionOutput()
    }

    private func updateResultOutput() {
        if let digits = self.pressedDigits {
            self.displayLabel.text = digits.mathList.stringValue
        } else if let calcConstant = self.pressedCalcConstant {
            self.displayLabel.text = calcConstant.value.stringRepresentation()
        } else if let lastResult = self.lastResult {
            self.displayLabel.text = lastResult.stringRepresentation()
        } else {
            self.displayLabel.text = "0"
        }
    }

    private func updateExpressionOutput() {
        if let expression = self.expression {
            let mathList = MTMathList()

            expression.forEach { token in
                switch token.tokenType {
                case .calcBracket(let calcBracket):
                    mathList.append(calcBracket.mathList)
                    mathList.addAtom(MTMathSpace(space: 5.0))
                    break
                case .mathOperator(let operatorToken):
                    mathList.append(operatorToken.operatorType.mathList)
                    mathList.addAtom(MTMathSpace(space: 5.0))
                    break
                case .operand(let operand):
                    mathList.addAtom(MTMathAtom(type: .placeholder, value: operand.description))
                    mathList.addAtom(MTMathSpace(space: 5.0))
                    break
                case .singleAction(let singleAction):
                    mathList.append(singleAction.mathList)
                    mathList.addAtom(MTMathSpace(space: 5.0))
                    break
                }
            }

            mathList.atoms.forEach { atom in
                atom.fontStyle = .roman
            }

            if let tmpMathList = self.tmpMathList {
                mathList.append(tmpMathList)
            }

            self.expressionLabel.mathList = mathList
        } else if let tmpMathList = self.tmpMathList {
            self.expressionLabel.mathList = tmpMathList
        } else {
            self.expressionLabel.mathList = nil
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Code here will execute before the rotation begins.
        // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]

        let toLandscape = size.width > size.height

        coordinator.animate(alongsideTransition: { context in
            // Place code here to perform animations during the rotation.
            // You can pass nil or leave this block empty if not necessary.
            self.switchToOrientation(toLandscape: toLandscape)
        }, completion: { context in
            // Place code here to perform animations during the rotation.
            // You can pass nil or leave this block empty if not necessary.
        })
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }

    func deselectAllButtons() {
        self.stackViewsWithButtons.forEach { stackView in
            stackView.arrangedSubviews.forEach { view in
                guard let buttonView = view as? CustomCalcButton else {
                    return
                }

                if (buttonView.customSelected) {
                    buttonView.customSelected = false
                }
            }
        }
    }

}

extension CalcViewController: CalcBrainDelegate {

    func updateInfixExpression(_ expression: Array<Token>) {
        self.expression = expression
        self.updateExpressionOutput()
    }

    func updateDisplayResult(_ result: Double) {
        self.lastResult = result
        self.updateOutput()
    }

}

extension CalcViewController: CustomCalcButtonDelegate {

    func onCalcButtonTap(_ calcButton: CustomCalcButton) {
        debugPrint("on calc button type: \(String(describing: calcButton.buttonType))")

        guard let buttonType = calcButton.calcButtonType else {
            return
        }

        self.deselectAllButtons()
        calcButton.customSelected = true

        self.tmpMathList = nil

        switch buttonType {
        case .digit(let calcDigit):
            self.handleDigitTap(calcDigit)
            self.tmpMathList = self.pressedDigits?.mathList
            self.updateResultOutput()
            break
        case .calcCommand(let calcCommand):
            self.tmpMathList = calcCommand.mathList
            self.handleCommandTap(calcCommand)
            break
        case .singleAction(let singleAction):
            self.handleSingleActionTap(singleAction)
            break
        case .calcConstant(let calcConstant):
            self.tmpMathList = calcConstant.mathList
            self.handleCalcConstantTap(calcConstant)
            self.updateResultOutput()
            break
        case .calcExtra(let calcExtra):
            self.handleCalcExtraTap(calcExtra)
            return
        case .calcBracket(let calcBracket):
            self.handleCalcBracketTap(calcBracket)
            break
        }

        self.updateExpressionOutput()
    }

}

enum CalcButtonType {
    case calcCommand(CalcCommand)
    case singleAction(CalcSingleAction)
    case digit(CalcDigit)
    case calcExtra(CalcExtra)
    case calcConstant(CalcConstant)
    case calcBracket(CalcBracket)

    var mathList: MTMathList {
        switch self {
        case .calcCommand(let calcCommand):
            return calcCommand.mathList
        case .singleAction(let singleAction):
            return singleAction.mathList
        case .digit(let calcDigit):
            return calcDigit.mathList
        case .calcExtra(let calcExtra):
            return calcExtra.mathList
        case .calcConstant(let calcConstant):
            return calcConstant.mathList
        case .calcBracket(let calcBracket):
            return calcBracket.mathList
        }
    }
}

class PressedDigits {

    public private (set) var pressedButtons: Array<CalcDigit> = []
    var isNegative: Bool = false

    var count: Int {
        return pressedButtons.count
    }

    var mathList: MTMathList {
        let mathList = self.value.mathList

        if let lastDigit = pressedButtons.last,
           lastDigit == .dot {
            mathList.addAtom(MTMathAtom(type: .placeholder, value: ","))
        }

        return mathList
    }

    var value: Double {
        if (self.count == 0) {
            return 0
        }

        var valueStr = ""
        self.pressedButtons.forEach { digit in
            valueStr.append(digit.value)
        }

        if let lastDigit = pressedButtons.last,
           lastDigit == .dot {
            valueStr.append("0")
        }

        guard var value = Double.fromString(valueStr) else {
            self.pressedButtons = []
            return 0
        }

        if (self.isNegative) {
            value = value * -1
        }

        return value
    }

    init(stringValue: String) {
        stringValue.forEach { character in
            if let digit = try? CalcDigit.valueOfChar(character) {
                self.add(digit)
            }
        }
    }

    init(_ digit: CalcDigit) {
        self.add(digit)
    }

    func add(_ digit: CalcDigit) {
        if (digit == .dot) {
            if (self.hasDot()) {
                return
            }
        }
        self.pressedButtons.append(digit)
    }

    private func hasDot() -> Bool {
        let addedDot = self.pressedButtons.first { addedDigit in
            addedDigit == .dot
        }

        return addedDot != nil
    }

}

protocol CalcAction: CustomStringConvertible {
    var mathList: MTMathList { get }
}

extension CalcAction {
    var description: String {
        return self.mathList.stringValue
    }
}

extension CalcViewController: CopyableLabelDelegate {

    func textWasPastedToCopyableLabel(_ copyableLabel: CopyableLabel) {
        if let text = copyableLabel.text {
            self.pressedDigits = PressedDigits(stringValue: text)
            self.tmpMathList = self.pressedDigits?.mathList
            self.updateExpressionOutput()
        }
    }

}

enum CalcSessionState {
    case activated
    case cleared
    case ended
}
