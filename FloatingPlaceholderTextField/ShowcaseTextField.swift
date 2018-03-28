//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

@IBDesignable
class ShowcaseTextField: FloatingPlaceholderTextField {

    private static let placeholderAppearance: FloatingPlaceholderViewAppearance = StandardFloatingPlaceholderViewAppearance.showcase

    private static let placeholderGeometry = FloatingPlaceholderViewGeometry.showcase

    convenience init() {
        self.init(placeholderBehaviour: .float)
    }

    init(placeholderBehaviour: PlaceholderBehaviour) {
        super.init(placeholderBehaviour: placeholderBehaviour,
                   placeholderAppearance: ShowcaseTextField.placeholderAppearance,
                   placeholderGeometry: ShowcaseTextField.placeholderGeometry)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(placeholderBehaviour: .float,
                   placeholderAppearance: ShowcaseTextField.placeholderAppearance,
                   placeholderGeometry: ShowcaseTextField.placeholderGeometry)
    }

    // MARK: - UIControl

    override var isEnabled: Bool {
        didSet {
            textColor = isEnabled ? .black : placeholderAppearance.disabledStyle.placeholderLabelColor
        }
    }

    // MARK: - IBDesignable

    override func prepareForInterfaceBuilder() {
        placeholder = "Placeholder"
        text = "Text"
        super.prepareForInterfaceBuilder()
    }
}
