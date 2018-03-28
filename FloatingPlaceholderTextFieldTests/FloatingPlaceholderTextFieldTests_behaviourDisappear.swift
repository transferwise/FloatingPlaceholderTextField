//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//


import XCTest
import FBSnapshotTestCase
@testable import FloatingPlaceholderTextField

final class FloatingPlaceholderTextFieldTests_behaviourDisappear: FloatingPlaceholderTextFieldTests {
    
    override func provideTextField() -> FloatingPlaceholderTextField {
        return FloatingPlaceholderTextField(placeholderBehaviour: .disappear,
                                            placeholderAppearance: StandardFloatingPlaceholderViewAppearance.test,
                                            placeholderGeometry: .testWhenLineHeightsNotSet)
    }
}
