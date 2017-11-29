//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public enum FloatingPlaceholderViewStyleState: Equatable {
    
    case inactive(enabled: Bool)
    case active
    // we might not show error, but apply error style
    case error(message: String?)

    public static func ==(lhs: FloatingPlaceholderViewStyleState, rhs: FloatingPlaceholderViewStyleState) -> Bool {
        switch (lhs, rhs) {
        case (.inactive(let lhsEnabled), .inactive(let rhsEnabled)):
            return lhsEnabled == rhsEnabled

        case (.active, .active):
            return true

        case (.error(let lhsErrorMessage), .error(let rhsErrorMessage)):
            return lhsErrorMessage == rhsErrorMessage

        default:
            return false
        }
    }
}

public protocol FloatingPlaceholderViewStyling {
    
    func placeholderLabelFont(isFloating: Bool) -> UIFont
    
    func placeholderLabelColor(forState state: FloatingPlaceholderViewStyleState, isFloating: Bool) -> UIColor
    
    func errorLabelFont() -> UIFont
    
    func errorLabelColor() -> UIColor
    
    func underlineColor(forState state: FloatingPlaceholderViewStyleState) -> UIColor
}
