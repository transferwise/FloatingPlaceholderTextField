//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

@objcMembers
open class FloatingPlaceholderTextField: UITextField {

    public enum PlaceholderBehaviour {
        case float
        case disappear
    }

    public let placeholderBehaviour: PlaceholderBehaviour
    public let placeholderGeometry: FloatingPlaceholderViewGeometry
    public let placeholderAppearance: FloatingPlaceholderViewAppearance

    open var deemphasisOnTextChange = true

    public init(placeholderBehaviour: PlaceholderBehaviour,
                placeholderAppearance: FloatingPlaceholderViewAppearance,
                placeholderGeometry: FloatingPlaceholderViewGeometry) {

        self.placeholderBehaviour = placeholderBehaviour
        self.placeholderGeometry = placeholderGeometry
        self.placeholderAppearance = placeholderAppearance
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    // MARK: Emphasis convenience API

    open var inlineMessage: String? {
        guard case let .emphasized(emphasis) = floatingState else {
            return nil
        }
        return emphasis.message
    }

    @objc
    open func emphasize(inlineMessage: String?, color: UIColor, animated: Bool = UIView.areAnimationsEnabled) {
        setEmphasis(
            FloatingPlaceholderViewEmphasizedState(
                message: inlineMessage,
                style: FloatingPlaceholderViewStyle(
                    placeholderLabelColor: color,
                    floatingPlaceholderLabelColor: color,
                    underlineColor: color
                ),
                inlineMessageLabelColor: color
            ),
            animated: animated
        )
    }

    open func deemphasize(animated: Bool = UIView.areAnimationsEnabled) {
        setEmphasis(nil, animated: animated)
        floatingState = emphasisGoneFallbackState
    }

    // MARK: Style API

    open func updateStyleState() {
        // if state is emphasis - we should not change it
        if case .emphasized = self.floatingState {
            return
        }
        self.floatingState = emphasisGoneFallbackState
    }

    open var floatingState: FloatingPlaceholderViewState  {
        get {
            return floatingPlaceholderView.styleState
        }
        set {
            floatingPlaceholderView.styleState = newValue
        }
    }

    public lazy var floatingPlaceholderView: FloatingPlaceholderView = {
        let v = FloatingPlaceholderView(styling: self.placeholderAppearance, geometry: self.placeholderGeometry)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - UIView

    open override func addSubview(_ view: UIView) {
        super.addSubview(view)

        if isTextPresentation(view) {
            UIView.performWithoutAnimation {
                view.frame = textRect(forBounds: bounds)
            }
        }

    }

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

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()

        forceLayoutWithoutAnimation()

        if result {
            updateResponderStatusDependencies()
        }
        return result
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()

        forceLayoutWithoutAnimation()

        if result {
            updateResponderStatusDependencies()
        }
        return result
    }

    // MARK: - UIControl

    open override var isEnabled: Bool {
        didSet {
            updateStyleState()
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

    private var emphasisGoneFallbackState: FloatingPlaceholderViewState {
        return isFirstResponder ? .active : .inactive(enabled: isEnabled)
    }

    private var isEmphasized: Bool {
        if case .emphasized = floatingState {
            return true
        }

        return false
    }

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
        tintColor = placeholderAppearance.activeStyle.floatingPlaceholderLabelColor
        font = placeholderAppearance.placeholderLabelFont
    }

    // Need to fixate text rect during resize animations else text will be distorted
    private var frozenTextRect: CGRect?

    private func freezeTextRect() {
        frozenTextRect = textRect(forBounds: bounds)
    }

    private func unfreezeTextRect() {
        frozenTextRect = nil
    }

    private func setEmphasis(_ emphasis: FloatingPlaceholderViewEmphasizedState?, animated: Bool) {
        if case let .emphasized(currentEmphasis) = floatingState, currentEmphasis == emphasis {
            return
        }
        
        freezeTextRect()

        let finishLayout = {
            self.unfreezeTextRect()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }

        let animated = animated && (window != nil)

        let state: FloatingPlaceholderViewState
        if let emphasis = emphasis {
            state = .emphasized(emphasis)
        } else {
            state = emphasisGoneFallbackState
        }
        floatingPlaceholderView.styleState = state

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
        if deemphasisOnTextChange {
            deemphasize(animated: animated)
        }
    }

    private func updateResponderStatusDependencies() {
        updateStyleState()
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

    private func forceLayoutWithoutAnimation() {
        // While UITextField switch active/inactive states,
        // it replaces UIFieldEditor <-> _UITextFieldContentView
        // to align this switch properly we need layout subviews
        UIView.performWithoutAnimation {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    /// While text field changing states, it adds/removes subviews.
    /// Even text erea might be presented with 2 different views:
    /// * _UITextFieldContentView for not first responder state
    /// * UIFieldEditor for first responder state
    /// This function allow check: does this view present text or it is any kind of accessory views
    private func isTextPresentation(_ view: UIView) -> Bool {

        guard let bakedViewClass = NSClassFromString("_UITextFieldContentView"),
            let editingView = NSClassFromString("UIFieldEditor") else {
                return false
        }

        return [bakedViewClass, editingView].contains { view.isKind(of: $0) }

    }
}
