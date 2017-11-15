//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public enum FloatingPlaceholderViewStyleState: Equatable {
    
    case inactive(enabled: Bool)
    case active
    case error
    
    public static func ==(lhs: FloatingPlaceholderViewStyleState, rhs: FloatingPlaceholderViewStyleState) -> Bool {
        switch (lhs, rhs) {
        case (.inactive(let lhsEnabled), .inactive(let rhsEnabled)):
            return lhsEnabled == rhsEnabled
            case (.active, .active),
                 (.error, .error):
            return true

        default:
            return false
        }
    }
}

public protocol FloatingPlaceholderViewStyling {
    
    func placeholderLabelFont(isFloating: Bool) -> UIFont
    
    func placeholderLabelColor(forState state: FloatingPlaceholderViewStyleState, isFloating: Bool) -> UIColor

    func bottomLabelFont() -> UIFont

    func bottomLabelColor(forState state: FloatingPlaceholderViewStyleState) -> UIColor
    
    func underlineColor(forState state: FloatingPlaceholderViewStyleState) -> UIColor
}
