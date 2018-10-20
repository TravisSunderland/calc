//
// Created by Vadim Sergeev on 17.03.18.
// Copyright (c) 2018 studyflow. All rights reserved.
//

import Foundation
import UIKit

extension CalcViewController {

    func switchToOrientation(toLandscape: Bool) {
        let orientation = UIDevice.current.orientation

        if (toLandscape) {
            self.displayLabel.font = UIFont.fontRegular(size: 60)
            self.displayLabelHeightConstraint.constant = 62
        } else {
            self.displayLabel.font = UIFont.fontRegular(size: 80)
            self.displayLabelHeightConstraint.constant = 82
        }

        self.stackView1.removeArrangedSubview(self.baseStackView1)
        self.baseStackView1.removeFromSuperview()
        self.stackView2.removeArrangedSubview(self.baseStackView2)
        self.baseStackView2.removeFromSuperview()
        self.stackView3.removeArrangedSubview(self.baseStackView3)
        self.baseStackView3.removeFromSuperview()
        self.stackView4.removeArrangedSubview(self.baseStackView4)
        self.baseStackView4.removeFromSuperview()
        self.stackView5.removeArrangedSubview(self.baseStackView5)
        self.baseStackView5.removeFromSuperview()

        self.stackView1.removeArrangedSubview(self.extraStackView1)
        self.extraStackView1.removeFromSuperview()
        self.stackView2.removeArrangedSubview(self.extraStackView2)
        self.extraStackView2.removeFromSuperview()
        self.stackView3.removeArrangedSubview(self.extraStackView3)
        self.extraStackView3.removeFromSuperview()
        self.stackView4.removeArrangedSubview(self.extraStackView4)
        self.extraStackView4.removeFromSuperview()
        self.stackView5.removeArrangedSubview(self.extraStackView5)
        self.extraStackView5.removeFromSuperview()

        if (toLandscape) {
            self.stackView1.addArrangedSubview(self.extraStackView1)
            self.stackView2.addArrangedSubview(self.extraStackView2)
            self.stackView3.addArrangedSubview(self.extraStackView3)
            self.stackView4.addArrangedSubview(self.extraStackView4)
            self.stackView5.addArrangedSubview(self.extraStackView5)
        }

        self.stackView1.addArrangedSubview(self.baseStackView1)
        self.stackView2.addArrangedSubview(self.baseStackView2)
        self.stackView3.addArrangedSubview(self.baseStackView3)
        self.stackView4.addArrangedSubview(self.baseStackView4)
        self.stackView5.addArrangedSubview(self.baseStackView5)

        let width2 = NSLayoutConstraint(item: self.baseStackView1,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.baseStackView2,
                attribute: NSLayoutAttribute.width,
                multiplier: 1,
                constant: 0)
        let width3 = NSLayoutConstraint(item: self.baseStackView1,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.baseStackView3,
                attribute: NSLayoutAttribute.width,
                multiplier: 1,
                constant: 0)
        let width4 = NSLayoutConstraint(item: self.baseStackView1,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.baseStackView4,
                attribute: NSLayoutAttribute.width,
                multiplier: 1,
                constant: 0)
        let width5 = NSLayoutConstraint(item: self.baseStackView1,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.baseStackView5,
                attribute: NSLayoutAttribute.width,
                multiplier: 1,
                constant: 0)

        let digit1Button = self.baseStackView4.arrangedSubviews[0]
        let digit2Button = self.baseStackView4.arrangedSubviews[1]
        let digit3Button = self.baseStackView4.arrangedSubviews[2]
        let digit0Button = self.baseStackView5.arrangedSubviews[0]
        let dotButton = self.baseStackView5.arrangedSubviews[1]

        let digit0ConstraintLeading = NSLayoutConstraint(item: digit1Button,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: digit0Button,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1,
                constant: 0)

        let digit0ConstraintTrailing = NSLayoutConstraint(item: digit2Button,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: digit0Button,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1,
                constant: 0)

        let dotConstraintTrailing = NSLayoutConstraint(item: digit3Button,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: dotButton,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1,
                constant: 0)

        self.stackView.addConstraints([width2, width3, width4, width5, digit0ConstraintLeading, digit0ConstraintTrailing, dotConstraintTrailing])

        applyOrientationChangeToStackView(self.extraStackView1, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.extraStackView2, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.extraStackView3, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.extraStackView4, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.extraStackView5, toLandscape: toLandscape)

        applyOrientationChangeToStackView(self.baseStackView1, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.baseStackView2, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.baseStackView3, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.baseStackView4, toLandscape: toLandscape)
        applyOrientationChangeToStackView(self.baseStackView5, toLandscape: toLandscape)
    }

    private func applyOrientationChangeToStackView(_ stackView: UIStackView, toLandscape: Bool) {
        stackView.arrangedSubviews.forEach { view in
            guard let calcButton = view as? CustomCalcButton else {
                return
            }
            calcButton.handleOrientationChanged(toLandscape)
        }
    }

}