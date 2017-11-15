//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import CoreGraphics
import FloatingPlaceholderTextField

extension FloatingPlaceholderViewGeometry {

    static let testWhenLineHeightsSet = FloatingPlaceholderViewGeometry(underlineHeight: 1,
                                                                        topToFloatingLabelOffset: 8,
                                                                        floatingAndBottomLabelLineHeight: 18,
                                                                        floatingToNonFloatingLabelOffset: 4,
                                                                        nonFloatingLabelLineHeight: 22,
                                                                        nonFloatingLabelToUnderlineOffset: 12,
                                                                        underlineToBottomLabelOffset: 8,
                                                                        leftRightViewToTextOffset: 8)

    static let testWhenLineHeightsNotSet = FloatingPlaceholderViewGeometry(underlineHeight: 1,
                                                                           topToFloatingLabelOffset: 8,
                                                                           floatingAndBottomLabelLineHeight: nil,
                                                                           floatingToNonFloatingLabelOffset: 4,
                                                                           nonFloatingLabelLineHeight: nil,
                                                                           nonFloatingLabelToUnderlineOffset: 12,
                                                                           underlineToBottomLabelOffset: 8,
                                                                           leftRightViewToTextOffset: 8)
}
