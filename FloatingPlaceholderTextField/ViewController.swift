//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private lazy var textField: ShowcaseTextField = {
        let f = ShowcaseTextField()
        f.placeholder = "How do you transfer money?"
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    private lazy var showErrorButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handleShowErrorButtonPressed), for: .touchUpInside)
        b.setTitle("Show Error", for: .normal)
        return b
    }()

    private lazy var dismissKeyboardButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handleDismissKeyboardButtonPressed), for: .touchUpInside)
        b.setTitle("Dismiss Keyboard", for: .normal)
        return b
    }()

    private lazy var toggleEnabledButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handleToggleEnabledButtonPressed), for: .touchUpInside)
        b.setTitle("Toggle Enabled", for: .normal)
        return b
    }()

    private func setupLayout() {
        view.addSubview(textField)
        textField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        view.addSubview(showErrorButton)
        showErrorButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).isActive = true
        showErrorButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        showErrorButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

        view.addSubview(dismissKeyboardButton)
        dismissKeyboardButton.topAnchor.constraint(equalTo: showErrorButton.bottomAnchor, constant: 24).isActive = true
        dismissKeyboardButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        dismissKeyboardButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

        view.addSubview(toggleEnabledButton)
        toggleEnabledButton.topAnchor.constraint(equalTo: dismissKeyboardButton.bottomAnchor, constant: 24).isActive = true
        toggleEnabledButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        toggleEnabledButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    @objc private func handleShowErrorButtonPressed() {
        textField.showError("Try TransferWise and send money with the real exchange rate!")
    }

    @objc private func handleDismissKeyboardButtonPressed() {
        _ = textField.resignFirstResponder()
    }

    @objc private func handleToggleEnabledButtonPressed() {
        textField.isEnabled = !textField.isEnabled
    }
}
