//
//  UIView+Border.swift
//  JokeGetter
//
//  Created by Paul on 05.05.2022.
//

import UIKit

@IBDesignable
extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            clipsToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set { layer.borderColor = newValue?.cgColor }
    }

}
