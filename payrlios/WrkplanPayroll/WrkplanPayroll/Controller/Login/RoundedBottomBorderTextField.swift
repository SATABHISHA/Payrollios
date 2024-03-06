import UIKit

@IBDesignable
class RoundedBottomBorderTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorderWithShadow()
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
