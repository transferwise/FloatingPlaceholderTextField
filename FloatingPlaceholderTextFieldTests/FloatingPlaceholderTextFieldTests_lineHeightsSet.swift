//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//


import XCTest
import FBSnapshotTestCase
@testable import FloatingPlaceholderTextField

final class FloatingPlaceholderTextFieldTests_lineHeightsSet: FloatingPlaceholderTextFieldTests {

    override func provideTextField() -> FloatingPlaceholderTextField {
        return FloatingPlaceholderTextField(placeholderBehaviour: .float,
                                            placeholderStyling: StandardFloatingPlaceholderViewStyling.test,
                                            placeholderGeometry: .testWhenLineHeightsSet,
                                            bottomTextBehaviour: .visibleOnlyAtErrorState)
    }
}
