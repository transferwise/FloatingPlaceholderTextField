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

    public var styleState: FloatingPlaceholderViewStyleState = .inactive(enabled: true) {
        didSet {
            guard styleState != oldValue else {
                return
            }
            updateErrorLabel()
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
        errorLabel.frame = calculateErrorLabelFrame()
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
        if error != nil {
            height += geometry.underlineToErrorLabelOffset
            height += calculateErrorLabelSize(boundingWidth: size.width).height
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

    private lazy var errorLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.font = self.styling.errorLabelFont()
        l.textColor = self.styling.errorLabelColor()
        l.numberOfLines = 0
        return l
    }()

    private let styling: FloatingPlaceholderViewStyling
    private let geometry: FloatingPlaceholderViewGeometry

    private var isAnimating = false

    private var _isFloating = false

    private var error: String? {
        guard case .error(let errorMessage) = styleState else {
            return nil
        }

        return errorMessage
    }

    private func updateErrorLabel() {

        if let value = error, let lineHeight = geometry.floatingAndErrorLabelLineHeight {
            let font = styling.errorLabelFont()
            var attributes: [NSAttributedStringKey: Any] = [.font: font]
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = lineHeight - font.lineHeight
            attributes[.paragraphStyle] = paragraph

            let attributedString = NSMutableAttributedString(string: value)
            attributedString.setAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))

            errorLabel.attributedText = attributedString
        } else {
            errorLabel.text = error
        }

        // Need this for show error animation
        errorLabel.frame = calculateErrorLabelFrame()

        invalidateIntrinsicContentSize()
    }

    private func commonInit() {
        clipsToBounds = true
        isUserInteractionEnabled = false
        addSubview(placeholderLabel)
        addSubview(underline)
        addSubview(errorLabel)
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
    }

    private func updateUnderlineColor() {
        underline.backgroundColor = styling.underlineColor(forState: styleState)
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
                                                           attributes: [.font: font],
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

    private func calculateErrorLabelFrame() -> CGRect {
        let y = calculateUnderlineFrame().maxY + geometry.underlineToErrorLabelOffset
        let size = calculateErrorLabelSize(boundingWidth: bounds.width)
        return CGRect(x: 0,
                      y: y,
                      width: size.width,
                      height: size.height)
    }

    private func calculateErrorLabelSize(boundingWidth: CGFloat) -> CGSize {
        if let error = error {
            let font = styling.errorLabelFont()
            let size = NSString(string: error).boundingRect(with: CGSize(width: boundingWidth, height: .greatestFiniteMagnitude),
                                                            options: [.usesLineFragmentOrigin],
                                                            attributes: [.font: font],
                                                            context: nil)
            let height: CGFloat
            if let lineHeight = geometry.floatingAndErrorLabelLineHeight {
                height = ceil(round(size.height / font.lineHeight) * lineHeight)
            } else {
                height = ceil(size.height)
            }
            
            return CGSize(width: boundingWidth, height: height)
        } else {
            return .zero
        }
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
            if let lineHeight = geometry.floatingAndErrorLabelLineHeight {
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
