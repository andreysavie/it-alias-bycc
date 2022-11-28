//
//  GradientBorderView.swift
//  JokeGetter
//
//  Created by Paul on 05.05.2022.
//

import UIKit

class GradientBorderButton: UIButton {
    var gradientColors: [UIColor] = [.systemGreen, .systemMint] {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let gradient = UIImage.gradientImage(bounds: bounds, colors: gradientColors)
        layer.borderColor = UIColor(patternImage: gradient).cgColor
    }
}
