//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public struct StandardFloatingPlaceholderViewAppearance: FloatingPlaceholderViewAppearance {

    // `floatingFont` is used as inline message label font too.
    // If `floatingInactiveColor` is `nil`, `inactiveColor` will be used as color for floating label in inactive state.
    public init(
        activeColor: UIColor,
        inactiveColor: UIColor,
        disabledColor: UIColor,
        underlineColor: UIColor,
        font: UIFont,
        floatingFont: UIFont,
        floatingInactiveColor: UIColor? = nil
    ) {
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.disabledColor = disabledColor
        self.underlineColor = underlineColor
        self.font = font
        self.floatingFont = floatingFont
        self.floatingInactiveColor = floatingInactiveColor
    }

    public var placeholderLabelFont: UIFont { return font }

    public var floatingPlaceholderLabelFont: UIFont { return floatingFont }

    public var inlineMessageLabelFont: UIFont { return floatingFont }

    public var activeStyle: FloatingPlaceholderViewStyle {
        return FloatingPlaceholderViewStyle(
            placeholderLabelColor: activeColor,
            floatingPlaceholderLabelColor: activeColor,
            underlineColor: activeColor
        )
    }

    public var inactiveStyle: FloatingPlaceholderViewStyle {
        return FloatingPlaceholderViewStyle(
            placeholderLabelColor: inactiveColor,
            floatingPlaceholderLabelColor: floatingInactiveColor ?? inactiveColor,
            underlineColor: underlineColor
        )
    }

    public var disabledStyle: FloatingPlaceholderViewStyle {
        return FloatingPlaceholderViewStyle(
            placeholderLabelColor: disabledColor,
            floatingPlaceholderLabelColor: disabledColor,
            underlineColor: underlineColor
        )
    }

    private let activeColor: UIColor
    private let inactiveColor: UIColor
    private let disabledColor: UIColor
    private let underlineColor: UIColor
    private let floatingInactiveColor: UIColor?

    private let font: UIFont
    private let floatingFont: UIFont
}

extension FloatingPlaceholderViewAppearance {

    static var showcase: FloatingPlaceholderViewAppearance {
        return StandardFloatingPlaceholderViewAppearance(
            activeColor: UIColor(hex: 0x00B9FF),
            inactiveColor: UIColor(hex: 0xA8AAAC),
            disabledColor: UIColor(hex: 0xD3D5D8),
            underlineColor: UIColor(hex: 0xE2E6E8),
            font: .systemFont(ofSize: 18),
            floatingFont: .systemFont(ofSize: 14),
            floatingInactiveColor: UIColor(hex: 0x6F8691)
        )
    }
}

extension UIColor {
    
    convenience init(hex: Int) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255,
                  alpha: 1)
    }
}
