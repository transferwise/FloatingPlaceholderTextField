//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import CoreGraphics

public struct FloatingPlaceholderViewGeometry {
    
    public var underlineHeight: CGFloat
    
    public var topToFloatingLabelOffset: CGFloat
    
    public var floatingAndBottomLabelLineHeight: CGFloat?
    
    public var floatingToNonFloatingLabelOffset: CGFloat
    
    public var nonFloatingLabelLineHeight: CGFloat?
    
    public var nonFloatingLabelToUnderlineOffset: CGFloat
    
    public var underlineToBottomLabelOffset: CGFloat
    
    public var leftRightViewToTextOffset: CGFloat
    
    public init(underlineHeight: CGFloat,
                topToFloatingLabelOffset: CGFloat,
                floatingAndBottomLabelLineHeight: CGFloat? = nil,
                floatingToNonFloatingLabelOffset: CGFloat,
                nonFloatingLabelLineHeight: CGFloat? = nil,
                nonFloatingLabelToUnderlineOffset: CGFloat,
                underlineToBottomLabelOffset: CGFloat,
                leftRightViewToTextOffset: CGFloat) {
        
        self.underlineHeight = underlineHeight
        self.topToFloatingLabelOffset = topToFloatingLabelOffset
        self.floatingAndBottomLabelLineHeight = floatingAndBottomLabelLineHeight
        self.floatingToNonFloatingLabelOffset = floatingToNonFloatingLabelOffset
        self.nonFloatingLabelLineHeight = nonFloatingLabelLineHeight
        self.nonFloatingLabelToUnderlineOffset = nonFloatingLabelToUnderlineOffset
        self.underlineToBottomLabelOffset = underlineToBottomLabelOffset
        self.leftRightViewToTextOffset = leftRightViewToTextOffset
    }
    
    public static let showcase = FloatingPlaceholderViewGeometry(underlineHeight: 1,
                                                                 topToFloatingLabelOffset: 8,
                                                                 floatingAndBottomLabelLineHeight: 18,
                                                                 floatingToNonFloatingLabelOffset: 4,
                                                                 nonFloatingLabelLineHeight: 22,
                                                                 nonFloatingLabelToUnderlineOffset: 12,
                                                                 underlineToBottomLabelOffset: 8,
                                                                 leftRightViewToTextOffset: 8)
}
