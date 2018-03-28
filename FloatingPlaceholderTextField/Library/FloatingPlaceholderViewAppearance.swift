//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public struct FloatingPlaceholderViewStyle: Equatable {

    public let placeholderLabelColor: UIColor

    public let floatingPlaceholderLabelColor: UIColor

    public let underlineColor: UIColor

    public init(placeholderLabelColor: UIColor, floatingPlaceholderLabelColor: UIColor, underlineColor: UIColor) {
        self.placeholderLabelColor = placeholderLabelColor
        self.floatingPlaceholderLabelColor = floatingPlaceholderLabelColor
        self.underlineColor = underlineColor
    }

    public static func ==(lhs: FloatingPlaceholderViewStyle, rhs: FloatingPlaceholderViewStyle) -> Bool {
        return lhs.placeholderLabelColor == rhs.placeholderLabelColor
            && lhs.floatingPlaceholderLabelColor == rhs.floatingPlaceholderLabelColor
            && lhs.underlineColor == rhs.underlineColor
    }
}

public protocol FloatingPlaceholderViewAppearance {

    var placeholderLabelFont: UIFont { get }

    var floatingPlaceholderLabelFont: UIFont { get }

    var inlineMessageLabelFont: UIFont { get }

    var activeStyle: FloatingPlaceholderViewStyle { get }

    var inactiveStyle: FloatingPlaceholderViewStyle { get }

    var disabledStyle: FloatingPlaceholderViewStyle { get }
}
