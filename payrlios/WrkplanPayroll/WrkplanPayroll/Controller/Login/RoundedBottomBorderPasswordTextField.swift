import UIKit

@IBDesignable
class RoundedBottomBorderPasswordTextField: UITextField {
    
    // Password toggle button
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye_closed"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    // Show/hide password
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            toggleButton.setImage(UIImage(named: "eye_closed"), for: .normal)
        } else {
            toggleButton.setImage(UIImage(named: "eye_open"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        addBottomBorderWithShadow()
        
        // Set right view as the toggle button
        rightView = toggleButton
        rightViewMode = .always
        isSecureTextEntry = true
    }
    
    func addBottomBorderWithShadow() {
       
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 0)
        borderLayer.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(borderLayer)
        
        self.layer.cornerRadius = 8.0 // Adjust the radius as needed
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 3
        self.layer.shadowRadius = 3.0
    }
}
