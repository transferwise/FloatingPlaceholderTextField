//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public struct StandardFloatingPlaceholderViewStyling: FloatingPlaceholderViewStyling {
    
    let activeColor: UIColor
    let inactiveColor: UIColor
    let disabledColor: UIColor
    let underlineColor: UIColor
    let errorColor: UIColor
    
    let font: UIFont
    // Used as error label font too
    let floatingFont: UIFont
    
    // If `nil`, `inactiveColor` will be used
    let floatingInactiveColor: UIColor?
    
    public init(activeColor: UIColor,
                inactiveColor: UIColor,
                disabledColor: UIColor,
                underlineColor: UIColor,
                errorColor: UIColor,
                font: UIFont,
                floatingFont: UIFont,
                floatingInactiveColor: UIColor? = nil,
                underlineInactiveColor: UIColor? = nil) {
        
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.disabledColor = disabledColor
        self.underlineColor = underlineColor
        self.errorColor = errorColor
        self.font = font
        self.floatingFont = floatingFont
        self.floatingInactiveColor = floatingInactiveColor
    }
    
    public func placeholderLabelFont(isFloating: Bool) -> UIFont {
        return isFloating ? floatingFont : font
    }
    
    public func placeholderLabelColor(forState state: FloatingPlaceholderViewStyleState, isFloating: Bool) -> UIColor {
        switch state {
        case .active:
            return activeColor
        case let .inactive(enabled):
            if !enabled {
                return disabledColor
            } else {
                return isFloating ? (floatingInactiveColor ?? inactiveColor) : inactiveColor
            }
        case .error:
            return errorColor
        }
    }
    
    public func errorLabelFont() -> UIFont {
        return placeholderLabelFont(isFloating: true)
    }
    
    public func errorLabelColor() -> UIColor {
        return placeholderLabelColor(forState: .error, isFloating: true)
    }
    
    public func underlineColor(forState state: FloatingPlaceholderViewStyleState) -> UIColor {
        switch state {
        case .active, .error:
            return placeholderLabelColor(forState: state, isFloating: true)
        case .inactive:
            return underlineColor
        }
    }
}

extension StandardFloatingPlaceholderViewStyling {
    
    public static let showcase = StandardFloatingPlaceholderViewStyling(activeColor: UIColor(hex: 0x00B9FF),
                                                                        inactiveColor: UIColor(hex: 0xA8AAAC),
                                                                        disabledColor: UIColor(hex: 0xD3D5D8),
                                                                        underlineColor: UIColor(hex: 0xE2E6E8),
                                                                        errorColor: UIColor(hex: 0xF53636),
                                                                        font: .systemFont(ofSize: 18),
                                                                        floatingFont: .systemFont(ofSize: 14),
                                                                        floatingInactiveColor: UIColor(hex: 0x6F8691))
}

extension UIColor {
    
    fileprivate convenience init(hex: Int) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255,
                  alpha: 1)
    }
}
