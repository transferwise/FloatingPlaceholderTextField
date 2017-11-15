//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

@IBDesignable
class ShowcaseTextField: FloatingPlaceholderTextField {

    private static let placeholderStyling: FloatingPlaceholderViewStyling = StandardFloatingPlaceholderViewStyling.showcase

    private static let placeholderGeometry = FloatingPlaceholderViewGeometry.showcase

    convenience init() {
        self.init(placeholderBehaviour: .float)
    }

    init(placeholderBehaviour: PlaceholderBehaviour) {
        super.init(placeholderBehaviour: placeholderBehaviour,
                   placeholderStyling: ShowcaseTextField.placeholderStyling,
                   placeholderGeometry: ShowcaseTextField.placeholderGeometry,
                   bottomTextBehaviour: .visibleOnlyAtErrorState)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(placeholderBehaviour: .float,
                   placeholderStyling: ShowcaseTextField.placeholderStyling,
                   placeholderGeometry: ShowcaseTextField.placeholderGeometry,
                   bottomTextBehaviour: .visibleOnlyAtErrorState)
    }

    // MARK: - UIControl

    override var isEnabled: Bool {
        didSet {
            textColor = isEnabled ? .black : placeholderStyling.placeholderLabelColor(forState: .inactive(enabled: false), isFloating: false)
        }
    }

    // MARK: - IBDesignable

    override func prepareForInterfaceBuilder() {
        placeholder = "Placeholder"
        text = "Text"
        super.prepareForInterfaceBuilder()
    }
}
