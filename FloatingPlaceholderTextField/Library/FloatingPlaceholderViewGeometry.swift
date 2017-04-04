//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import CoreGraphics

public struct FloatingPlaceholderViewGeometry {
    
    public var underlineHeight: CGFloat
    
    public var topToFloatingLabelOffset: CGFloat
    
    public var floatingAndErrorLabelLineHeight: CGFloat?
    
    public var floatingToNonFloatingLabelOffset: CGFloat
    
    public var nonFloatingLabelLineHeight: CGFloat?
    
    public var nonFloatingLabelToUnderlineOffset: CGFloat
    
    public var underlineToErrorLabelOffset: CGFloat
    
    public var leftRightViewToTextOffset: CGFloat
    
    public init(underlineHeight: CGFloat,
                topToFloatingLabelOffset: CGFloat,
                floatingAndErrorLabelLineHeight: CGFloat? = nil,
                floatingToNonFloatingLabelOffset: CGFloat,
                nonFloatingLabelLineHeight: CGFloat? = nil,
                nonFloatingLabelToUnderlineOffset: CGFloat,
                underlineToErrorLabelOffset: CGFloat,
                leftRightViewToTextOffset: CGFloat) {
        
        self.underlineHeight = underlineHeight
        self.topToFloatingLabelOffset = topToFloatingLabelOffset
        self.floatingAndErrorLabelLineHeight = floatingAndErrorLabelLineHeight
        self.floatingToNonFloatingLabelOffset = floatingToNonFloatingLabelOffset
        self.nonFloatingLabelLineHeight = nonFloatingLabelLineHeight
        self.nonFloatingLabelToUnderlineOffset = nonFloatingLabelToUnderlineOffset
        self.underlineToErrorLabelOffset = underlineToErrorLabelOffset
        self.leftRightViewToTextOffset = leftRightViewToTextOffset
    }
    
    public static let showcase = FloatingPlaceholderViewGeometry(underlineHeight: 1,
                                                                 topToFloatingLabelOffset: 8,
                                                                 floatingAndErrorLabelLineHeight: 18,
                                                                 floatingToNonFloatingLabelOffset: 4,
                                                                 nonFloatingLabelLineHeight: 22,
                                                                 nonFloatingLabelToUnderlineOffset: 12,
                                                                 underlineToErrorLabelOffset: 8,
                                                                 leftRightViewToTextOffset: 8)
}
