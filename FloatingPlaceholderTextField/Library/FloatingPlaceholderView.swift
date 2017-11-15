//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

public final class FloatingPlaceholderView: UIView {

    public init(styling: FloatingPlaceholderViewStyling, geometry: FloatingPlaceholderViewGeometry) {
        self.styling = styling
        self.geometry = geometry
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    public var placeholder: String? {
        didSet {
            guard oldValue != placeholder else {
                return
            }
            updatePlaceholderLabel()
        }
    }

    public var isFloating: Bool {
        set {
            setIsFloating(newValue, animated: false)
        }
        get {
            return _isFloating
        }
    }

    public func setIsFloating(_ isFloating: Bool, animated: Bool) {
        guard self.isFloating != isFloating else {
            return
        }

        let oldAnimationSize = calculateTextLabelFrame(ignorePreferredMaxLayoutWidth: true).size

        _isFloating = isFloating

        let animated = animated && (window != nil)
        if animated {
            let oldFrame = placeholderLabel.frame
            let newFrame = calculateTextLabelFrame(ignorePreferredMaxLayoutWidth: false)

            isAnimating = true

            updatePlaceholderLabel()
            placeholderLabel.frame = newFrame

            let newAnimationSize = calculateTextLabelFrame(ignorePreferredMaxLayoutWidth: true).size

            // Transform and shift new placeholder to look approximately as an old one

            // Scale to imitate old font size
            let xScale = oldAnimationSize.width / newAnimationSize.width
            let yScale = oldAnimationSize.height / newAnimationSize.height
            placeholderLabel.transform = CGAffineTransform(scaleX: xScale, y: yScale)

            // Shift (taking transform into account) so it's still left aligned
            let xShift = (newFrame.width * (xScale - 1)) / 2
            placeholderLabel.center = CGPoint(x: placeholderLabel.center.x + xShift, y: oldFrame.midY)

            // Simultaneously change position and size back to normal
            let animations = {
                self.placeholderLabel.transform = CGAffineTransform.identity
                self.placeholderLabel.center = CGPoint(x: newFrame.midX, y: newFrame.midY)
            }

            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.7,
                           options: .curveEaseInOut,
                           animations: animations) { _ in

                self.isAnimating = false
                self.setNeedsLayout()
            }
        } else {
            updatePlaceholderLabel()
        }
    }

    public var bottomText: NSAttributedString? {
        didSet {

            updateBottomLabelStyle()
            bottomLabel.attributedText = bottomText


            invalidateIntrinsicContentSize()
        }
    }

    public var styleState: FloatingPlaceholderViewStyleState = .inactive(enabled: true) {
        didSet {
            guard oldValue != styleState else {
                return
            }
            
            updateStyleStateDependencies()
        }
    }

    public func inputAreaRect() -> CGRect {
        let y = geometry.topToFloatingLabelOffset
            + placeholderLabelHeight(isFloating: true)
            + geometry.floatingToNonFloatingLabelOffset
        let height = placeholderLabelHeight(isFloating: false)
        return CGRect(x: 0, y: y, width: bounds.width, height: height)
    }

    public func leftViewRect(forSize size: CGSize) -> CGRect {
        return CGRect(x: 0, y: leftRightViewMinY(forSize: size), width: size.width, height: size.height)
    }

    public func rightViewRect(forSize size: CGSize) -> CGRect {
        return CGRect(x: bounds.width - size.width,
                      y: leftRightViewMinY(forSize: size),
                      width: size.width,
                      height: size.height)
    }

    public var preferredPlaceholderMaxLayoutWidth: CGFloat? {
        didSet {
            if oldValue == nil, preferredPlaceholderMaxLayoutWidth == nil {
                return
            }
            if let old = oldValue, let new = preferredPlaceholderMaxLayoutWidth, abs(old - new) <= .ulpOfOne {
                return
            }
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    // MARK: - UIView

    public override func layoutSubviews() {
        guard !isAnimating else {
            return
        }
        placeholderLabel.frame = calculateTextLabelFrame(ignorePreferredMaxLayoutWidth: false)
        bottomLabel.frame = calculateBottomLabelFrame()
        underline.frame = calculateUnderlineFrame()
    }

    public override var intrinsicContentSize: CGSize {
        let fittingSize = sizeThatFits(CGSize(width: preferredPlaceholderMaxLayoutWidth ?? CGFloat.greatestFiniteMagnitude,
                                              height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: fittingSize.width, height: fittingSize.height)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height = geometry.topToFloatingLabelOffset
        height += placeholderLabelHeight(isFloating: true)
        height += geometry.floatingToNonFloatingLabelOffset
        height += placeholderLabelHeight(isFloating: false)
        height += geometry.nonFloatingLabelToUnderlineOffset
        height += geometry.underlineHeight
        
        if bottomText != nil {
            height += geometry.underlineToBottomLabelOffset
            height += calculateBottomLabelSize(boundingWidth: size.width).height
        }
        return CGSize(width: size.width, height: height)
    }

    // MARK: - Private

    private lazy var placeholderLabel: UILabel = {
        return UILabel(frame: .zero)
    }()

    private lazy var underline: UIView = {
        return UIView(frame: .zero)
    }()

    private lazy var bottomLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.numberOfLines = 0
        return l
    }()

    private let styling: FloatingPlaceholderViewStyling
    private let geometry: FloatingPlaceholderViewGeometry

    private var isAnimating = false

    private var _isFloating = false

    private func commonInit() {
        clipsToBounds = true
        isUserInteractionEnabled = false
        addSubview(placeholderLabel)
        addSubview(underline)
        addSubview(bottomLabel)
        updateUnderlineColor()
    }

    private func updatePlaceholderLabel() {
        placeholderLabel.font = styling.placeholderLabelFont(isFloating: isFloating)
        placeholderLabel.textColor = styling.placeholderLabelColor(forState: styleState, isFloating: isFloating)
        placeholderLabel.text = placeholder
        setNeedsLayout()
    }

    private func updateStyleStateDependencies() {
        updatePlaceholderLabel()
        updateUnderlineColor()
        updateBottomLabelStyle()
    }

    private func updateUnderlineColor() {
        underline.backgroundColor = styling.underlineColor(forState: styleState)
    }
    
    private func updateBottomLabelStyle() {
        guard let bottomText = bottomText else {
            bottomLabel.attributedText = self.bottomText
            return
        }

        let fullRange = NSRange(location: 0, length: bottomText.length)

        // to save all existed local attributes - we need save them, apply global, re-apply saved local attributes
        var existedAttributes = Array<(NSRange, [String: Any])>()
        bottomText.enumerateAttributes(in: fullRange, options: []) {
            (attribues, range, _) in
            existedAttributes.append((range, attribues))
        }

        let styledBottomText = NSMutableAttributedString(string: bottomText.string)

        let color = styling.bottomLabelColor(forState: styleState)
        let font = styling.bottomLabelFont()

        var stylingAttributes: [String: Any] = [NSFontAttributeName: font,
                                                NSForegroundColorAttributeName: color]
        let paragraph = NSMutableParagraphStyle()
        if let lineHeight = geometry.floatingAndBottomLabelLineHeight {
            paragraph.lineSpacing = lineHeight - font.lineHeight
        }
        paragraph.lineBreakMode = .byWordWrapping
        
        stylingAttributes[NSParagraphStyleAttributeName] = paragraph

        styledBottomText.addAttributes(stylingAttributes, range: NSRange(location: 0, length: bottomText.length))

        for existedAttribute in existedAttributes {
            styledBottomText.addAttributes(existedAttribute.1, range: existedAttribute.0)
        }

        bottomLabel.attributedText = styledBottomText
    }

    /**
     * - Parameter ignorePreferredMaxLayoutWidth: Pass `true` to get result not constrained by width, used to
     * calculate placeholder transform scaling factors to animate it's size change; pass `false` if result will be used
     * to layout placeholder.
     */
    private func calculateTextLabelFrame(ignorePreferredMaxLayoutWidth: Bool) -> CGRect {
        let width: CGFloat
        if let text = placeholder {
            let font = styling.placeholderLabelFont(isFloating: isFloating)
            let size = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                                           options: [],
                                                           attributes: [NSFontAttributeName: font],
                                                           context: nil)
            var w = ceil(size.width)
            if !ignorePreferredMaxLayoutWidth, let maxLayoutWidth = preferredPlaceholderMaxLayoutWidth {
                w = min(w, maxLayoutWidth)
            }
            width = w
        } else {
            width = 0
        }

        let y: CGFloat
        let height: CGFloat
        if isFloating {
            y = geometry.topToFloatingLabelOffset
            height = placeholderLabelHeight(isFloating: true)
        } else {
            y = geometry.topToFloatingLabelOffset
                + placeholderLabelHeight(isFloating: true)
                + geometry.floatingToNonFloatingLabelOffset
            height = placeholderLabelHeight(isFloating: false)
        }
        return CGRect(x: 0,
                      y: y,
                      width: width,
                      height: height)
    }

    private func calculateUnderlineFrame() -> CGRect {
        let y = geometry.topToFloatingLabelOffset
            + placeholderLabelHeight(isFloating: true)
            + geometry.floatingToNonFloatingLabelOffset
            + placeholderLabelHeight(isFloating: false)
            + geometry.nonFloatingLabelToUnderlineOffset
        return CGRect(x: 0, y: y, width: bounds.width, height: geometry.underlineHeight)
    }

    private func calculateBottomLabelFrame() -> CGRect {
        let y = calculateUnderlineFrame().maxY + geometry.underlineToBottomLabelOffset
        let size = calculateBottomLabelSize(boundingWidth: bounds.width)
        return CGRect(x: 0,
                      y: y,
                      width: size.width,
                      height: size.height)
    }

    private func calculateBottomLabelSize(boundingWidth: CGFloat) -> CGSize {
        guard let styledBottomText = bottomLabel.attributedText else {
            return .zero
        }

        let size = styledBottomText.boundingRect(with: CGSize(width: boundingWidth, height: .greatestFiniteMagnitude),
                                                 options: [.usesLineFragmentOrigin],
                                                 context: nil)

        let height = ceil(size.height)
        
        return CGSize(width: boundingWidth, height: height)
    }

    private func leftRightViewMinY(forSize size: CGSize) -> CGFloat {
        return geometry.topToFloatingLabelOffset
            + placeholderLabelHeight(isFloating: true)
            + geometry.floatingToNonFloatingLabelOffset
            + placeholderLabelHeight(isFloating: false) / 2
            - size.height / 2
    }

    private func placeholderLabelHeight(isFloating: Bool) -> CGFloat {
        if isFloating {
            if let lineHeight = geometry.floatingAndBottomLabelLineHeight {
                return lineHeight
            }
        } else {
            if let lineHeight = geometry.nonFloatingLabelLineHeight {
                return lineHeight
            }
        }
        return ceil(styling.placeholderLabelFont(isFloating: isFloating).lineHeight)
    }
}
