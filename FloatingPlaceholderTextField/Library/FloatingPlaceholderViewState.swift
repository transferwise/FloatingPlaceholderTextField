//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public struct FloatingPlaceholderViewEmphasizedState: Equatable {

    // We might only apply a style without showing a message.
    public let message: String?

    public let style: FloatingPlaceholderViewStyle

    public let inlineMessageLabelColor: UIColor

    public init(message: String?, style: FloatingPlaceholderViewStyle, inlineMessageLabelColor: UIColor) {
        self.message = message
        self.style = style
        self.inlineMessageLabelColor = inlineMessageLabelColor
    }

    public static func ==(lhs: FloatingPlaceholderViewEmphasizedState, rhs: FloatingPlaceholderViewEmphasizedState) -> Bool {
        return lhs.message == rhs.message
            && lhs.style == rhs.style
            && lhs.inlineMessageLabelColor == rhs.inlineMessageLabelColor
    }
}

public enum FloatingPlaceholderViewState: Equatable {

    case inactive(enabled: Bool)
    case active
    case emphasized(FloatingPlaceholderViewEmphasizedState)

    public static func ==(lhs: FloatingPlaceholderViewState, rhs: FloatingPlaceholderViewState) -> Bool {
        switch (lhs, rhs) {
        case let (.inactive(lhsEnabled), .inactive(rhsEnabled)):
            return lhsEnabled == rhsEnabled

        case (.active, .active):
            return true

        case let (.emphasized(lhs), .emphasized(rhs)):
            return lhs == rhs

        default:
            return false
        }
    }
}
