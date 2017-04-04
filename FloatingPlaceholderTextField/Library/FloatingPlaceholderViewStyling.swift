//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public enum FloatingPlaceholderViewStyleState {
    
    case inactive(enabled: Bool)
    case active
    case error
}

public protocol FloatingPlaceholderViewStyling {
    
    func placeholderLabelFont(isFloating: Bool) -> UIFont
    
    func placeholderLabelColor(forState state: FloatingPlaceholderViewStyleState, isFloating: Bool) -> UIColor
    
    func errorLabelFont() -> UIFont
    
    func errorLabelColor() -> UIColor
    
    func underlineColor(forState state: FloatingPlaceholderViewStyleState) -> UIColor
}
