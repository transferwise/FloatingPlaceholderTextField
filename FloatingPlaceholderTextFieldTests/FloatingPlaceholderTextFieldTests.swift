//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//


import XCTest
import FBSnapshotTestCase
@testable import FloatingPlaceholderTextField

class FloatingPlaceholderTextFieldTests: FBSnapshotTestCase {
    
    private var field: FloatingPlaceholderTextField!
    private var window: UIWindow!
    
    func provideTextField() -> FloatingPlaceholderTextField {
        fatalError("\(#function) not implemented")
    }
    
    override func setUp() {
        super.setUp()
        
        UIView.setAnimationsEnabled(false)
        
        field = provideTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Company Name"
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.addSubview(field)
        
        field.widthAnchor.constraint(equalToConstant: 375).isActive = true
    }
    
    override func tearDown() {
        field = nil
        window = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }
    
    // Default test case is: has no text, no error, placeholder is set
    
    func test_defaultState() {
        window.layoutIfNeeded()
        verifyView()
    }
    
    func test_whenContainsText() {
        field.text = "TransferWise"
        verifyView()
    }

    func test_whenContainsText_hasError() {
        field.text = "E Corp"
        field.showError("Sorry, but this company does not provide lowest possible cost", animated: false)
        verifyView()
    }
    
    private func verifyView(file: StaticString = #file, line: UInt = #line) {
        window.layoutIfNeeded()
        FBSnapshotVerifyView(field, file: file, line: line)
    }
    
    func test_whenTextChanges_givenHadError_errorIsHidden() {
        field.text = "foo"
        field.showError("error", animated: false)
        field.text = "bar"
        XCTAssertNil(field.error)
    }
}
