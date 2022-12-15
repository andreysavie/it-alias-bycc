//
//  GradientBorderView.swift
//  JokeGetter
//
//  Created by Paul on 05.05.2022.
//

import UIKit

final class GradientBorderButton: UIButton {
    var gradientColors: [UIColor] = [.systemGreen, .systemTeal] {
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
