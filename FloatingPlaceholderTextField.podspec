Pod::Spec.new do |s|
  s.name         = "FloatingPlaceholderTextField"
  s.platform     = :ios
  s.version      = "3.0.1"
  s.summary      = "Customizable UITextField subclass with floating placeholder"
  s.homepage     = "https://github.com/transferwise/FloatingPlaceholderTextField"
  s.license      = 'MIT'
  s.author       = 'TransferWise'
  s.source       = { :git => "https://github.com/transferwise/FloatingPlaceholderTextField.git", :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.frameworks   = 'UIKit', 'CoreGraphics'
  s.source_files = 'FloatingPlaceholderTextField/Library'
end
