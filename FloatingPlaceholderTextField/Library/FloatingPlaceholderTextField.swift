//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

open class FloatingPlaceholderTextField: UITextField {

    public enum PlaceholderBehaviour {
        case float
        case disappear
    }

    public let placeholderBehaviour: PlaceholderBehaviour
    public let placeholderGeometry: FloatingPlaceholderViewGeometry
    public let placeholderStyling: FloatingPlaceholderViewStyling

    open var hideErrorOnTextChange = true

    public init(placeholderBehaviour: PlaceholderBehaviour,
                placeholderStyling: FloatingPlaceholderViewStyling,
                placeholderGeometry: FloatingPlaceholderViewGeometry) {

        self.placeholderBehaviour = placeholderBehaviour
        self.placeholderGeometry = placeholderGeometry
        self.placeholderStyling = placeholderStyling
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    open var error: String? {
        return floatingPlaceholderView.error
    }

    open func showError(_ error: String, animated: Bool = UIView.areAnimationsEnabled) {
        setError(error, animated: animated)
    }

    open func hideError(animated: Bool = UIView.areAnimationsEnabled) {
        setError(nil, animated: animated)
    }

    // MARK: - UIView

    open override func layoutSubviews() {
        super.layoutSubviews()
        let oldSize = floatingPlaceholderView.intrinsicContentSize
        floatingPlaceholderView.preferredPlaceholderMaxLayoutWidth = textRect(forBounds: bounds).width
        floatingPlaceholderView.layoutIfNeeded()
        if oldSize != floatingPlaceholderView.intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return floatingPlaceholderView.intrinsicContentSize
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return floatingPlaceholderView.sizeThatFits(size)
    }

    // MARK: - UIResponder

    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            updateResponderStatusDependencies()
        }
        return result
    }

    open override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            updateResponderStatusDependencies()
        }
        return result
    }

    // MARK: - UIControl

    open override var isEnabled: Bool {
        didSet {
            floatingPlaceholderView.isEnabled = isEnabled
        }
    }

    // MARK: - UITextField

    open override var leftView: UIView? {
        didSet {
            if let v = leftView {
                v.bounds.size = v.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            }
            setNeedsLayout()
        }
    }

    open override var rightView: UIView? {
        didSet {
            if let v = rightView {
                v.bounds.size = v.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            }
            setNeedsLayout()
        }
    }

    open override var placeholder: String? {
        set {
            guard _placeholder != newValue else {
                return
            }
            _placeholder = newValue
            updatePlaceholderDependencies()
        }
        get {
            return _placeholder
        }
    }

    open override var text: String? {
        set {
            guard newValue != text else {
                return
            }
            super.text = newValue
            updateTextDependencies(animated: false)
        }
        get {
            return super.text
        }
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let frozen = frozenTextRect {
            return frozen
        }
        var result = floatingPlaceholderView.inputAreaRect()
        result.size.height = bounds.height - result.minY
        if let leftView = leftView {
            let shift = floatingPlaceholderView.leftViewRect(forSize: leftView.bounds.size).width
                + placeholderGeometry.leftRightViewToTextOffset
            result.origin.x = shift
            result.size.width -= shift
        }
        if let rightView = rightView {
            let shift = floatingPlaceholderView.rightViewRect(forSize: rightView.bounds.size).width
                + placeholderGeometry.leftRightViewToTextOffset
            result.size.width -= shift
        }
        return result
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return floatingPlaceholderView.leftViewRect(forSize: leftView?.bounds.size ?? .zero)
    }

    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return floatingPlaceholderView.rightViewRect(forSize: rightView?.bounds.size ?? .zero)
    }

    // MARK: - Actions

    @objc private func editingChanged() {
        updateTextDependencies(animated: UIView.areAnimationsEnabled)
    }

    // MARK: - Private

    private var _placeholder: String?

    private lazy var floatingPlaceholderView: FloatingPlaceholderView = {
        let v = FloatingPlaceholderView(styling: self.placeholderStyling, geometry: self.placeholderGeometry)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private func commonInit() {
        setupAppearance()
        contentVerticalAlignment = .top
        addSubview(floatingPlaceholderView)

        floatingPlaceholderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        floatingPlaceholderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        floatingPlaceholderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        floatingPlaceholderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    private func setupAppearance() {
        tintColor = placeholderStyling.placeholderLabelColor(forState: .active, isFloating: true)
        font = placeholderStyling.placeholderLabelFont(isFloating: false)
    }

    // Need to fixate text rect during resize animations else text will be distorted
    private var frozenTextRect: CGRect?

    private func freezeTextRect() {
        frozenTextRect = textRect(forBounds: bounds)
    }

    private func unfreezeTextRect() {
        frozenTextRect = nil
    }

    private func setError(_ error: String?, animated: Bool) {
        guard floatingPlaceholderView.error != error else {
            return
        }
        
        freezeTextRect()

        let finishLayout = {
            self.unfreezeTextRect()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }

        let animated = animated && (window != nil)

        floatingPlaceholderView.error = error

        if animated {
            let animations = {
                self.invalidateIntrinsicContentSize()

                // Need to layout all parents so size change is animated smoothly
                var ptr = self.superview
                while let v = ptr {
                    v.setNeedsLayout()
                    v.layoutIfNeeded()
                    if v is UIScrollView {
                        // There is no point in a propagation of force-layout after hitting UIScrollView.
                        // Also fixes problem when calling `setNeedsLayout` and then `layoutIfNeeded` on some UIKit
                        // internal classes (maybe it’s UILayoutContainerView) changes contentInsets of UIScrollView.
                        break
                    }
                    ptr = v.superview
                }
            }

            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: .curveEaseInOut,
                animations: animations,
                completion: { _ in finishLayout() }
            )
        } else {
            invalidateIntrinsicContentSize()
            finishLayout()
        }
    }

    private func updateTextDependencies(animated: Bool) {
        updatePlaceholderPosition(animated: animated)
        if hideErrorOnTextChange {
            hideError(animated: animated)
        }
    }

    private func updateResponderStatusDependencies() {
        updateFloatingLabelViewIsActive()
        updatePlaceholderPosition(animated: UIView.areAnimationsEnabled)
    }

    private func updatePlaceholderPosition(animated: Bool) {
        let isFloating = shouldPutAwayPlaceholder()

        switch placeholderBehaviour {
        case .float:
            floatingPlaceholderView.setIsFloating(isFloating, animated: animated)
        case .disappear:
            floatingPlaceholderView.placeholder = isFloating ? nil : _placeholder
        }
    }

    private func shouldPutAwayPlaceholder() -> Bool {
        let textNonEmpty = !(text?.isEmpty ?? true)
        return isFirstResponder || textNonEmpty
    }

    private func updatePlaceholderDependencies() {
        switch placeholderBehaviour {
        case .float:
            floatingPlaceholderView.placeholder = placeholder
        case .disappear:
            floatingPlaceholderView.placeholder = shouldPutAwayPlaceholder() ? nil : _placeholder
        }
    }

    private func updateFloatingLabelViewIsActive() {
        floatingPlaceholderView.isActive = isFirstResponder
    }
}
