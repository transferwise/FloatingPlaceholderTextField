//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit
import FloatingPlaceholderTextField

extension StandardFloatingPlaceholderViewStyling {

    static let test = StandardFloatingPlaceholderViewStyling(activeColor: UIColor(hex: 0x00B9FF),
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
