//
//  ViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 16/11/20.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import Toast_Swift
import CoreLocation


 
class LoginViewController: UIViewController{

    @IBOutlet weak var corpId: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnCheckBox: UIButton!
    var checkBtnYN = 0
    //---Declaring shared preferences----
    let sharedpreferences=UserDefaults.standard
    
    var loginResult = false
    var mutableData = NSMutableData()
    var arrRes = [[String:AnyObject]]()
    var foundCharacters = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        btnCheckBox.setImage(UIImage(named:"check_box_empty"), for: .normal)
        btnCheckBox.setImage(UIImage(named:"check_box"), for: .selected)
        
        corpId.setLeftPaddingPoints(12)
        userName.setLeftPaddingPoints(12)
        password.setLeftPaddingPoints(12)
        if sharedpreferences.object(forKey: "CorpIDForLogin") != nil{
            corpId.text = sharedpreferences.object(forKey: "CorpIDForLogin") as? String
        }
        
        corpId.attributedPlaceholder = NSAttributedString(string: "Corporate ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        userName.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        //============keyboard will show/hide, code starts==========
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //============keyboard will show/hide, code ends===========
        
        //--------to hide keyboard, code starts-----
        corpId.resignFirstResponder()
        userName.resignFirstResponder()
        password.resignFirstResponder()
        //--------to hide keyboard code ends------
    }
    
    //----for autologin if "Stay sign in has been checked", code starts------
    override func viewDidAppear(_ animated: Bool) {
        if sharedpreferences.object(forKey: "UserId") != nil {
            let jsonString = sharedpreferences.string(forKey: "EmployeeJson") ?? ""
                let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)
               
            
            UserSingletonModel.sharedInstance.employeeJson = try? JSON(data: jsonData!)
            UserSingletonModel.sharedInstance.user_id = sharedpreferences.object(forKey: "UserId") as? Int
            UserSingletonModel.sharedInstance.user_type = sharedpreferences.object(forKey: "UserType") as? String
            // self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "home", sender: nil)
            
            
        }
    }
    //----for autologin if "Stay sign in has been checked", code ends------
    
    @IBAction func checkMarkedTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                if(!sender.isSelected){
                    sender.isSelected = true
                    sender.transform = .identity
                    self.checkBtnYN = 1
                    print("checked", self.checkBtnYN)
                }else{
                    sender.isSelected = false
                    sender.transform = .identity
                    self.checkBtnYN = 0
                    print("Un checked")
                }
            }, completion: nil)
        }
        
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        corpId.resignFirstResponder()
        userName.resignFirstResponder()
        password.resignFirstResponder()
        loaderStart()
        self.Validate()
    }
    
    func Validate(){
        if (corpId.text == "" || userName.text == "" || password.text == ""){
            loaderEnd()
            var style = ToastStyle()
            
            // this is just one of many style options
            style.messageColor = .white
            
            // present the toast with the new style
            self.view.makeToast("Field cannot be left empty", duration: 3.0, position: .bottom, style: style)
        }else {
//            self.loginAPICall()
            if Connectivity.isConnectedToInternet {
                
                self.login()
            }
            else{
                loaderEnd()
                print("No Internet is available")
                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                // present the toast with the new style
                self.view.makeToast("No Internet Connection", duration: 3.0, position: .bottom, style: style)
                }
             }
    }
    
    func login(){
        let url = BASE_URL + "login/\(corpId.text!)/\(userName.text!)/\(password.text!)"
        AF.request(url).responseJSON{ (responseData) -> Void in
                   if((responseData.value ?? "") != nil){
                       self.dismiss(animated: true, completion: nil)  //----dismissing the loader
                       let swiftyJsonVar=JSON(responseData.value!)
                       print(swiftyJsonVar)
                    if(swiftyJsonVar["response"]["status"].stringValue == "true"){
                    print(swiftyJsonVar["company"]["address_line1"].stringValue)
                    UserSingletonModel.sharedInstance.employeeJson = swiftyJsonVar
                    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
                    print("testing-=>",swiftyJsonvar1["employee"]["father_husband_name"].stringValue)
                    
                    UserSingletonModel.sharedInstance.user_id = swiftyJsonVar["user"]["user_id"].intValue
                    UserSingletonModel.sharedInstance.user_type = swiftyJsonVar["user"]["user_type"].stringValue
                    
                    //====================setting shared preference variables, code starts==============
                    if self.checkBtnYN == 1{
                        self.sharedpreferences.set(UserSingletonModel.sharedInstance.user_id, forKey: "UserId")
                        self.sharedpreferences.set(UserSingletonModel.sharedInstance.user_type, forKey: "UserType")
                        self.sharedpreferences.setValue(swiftyJsonVar.rawString(), forKey: "EmployeeJson")
                        self.sharedpreferences.synchronize()
                    }
                        
                        var style = ToastStyle()
                        
                        // this is just one of many style options
                        style.messageColor = .white
                        self.view.makeToast(swiftyJsonVar["response"]["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                        self.loaderEnd()
                        self.performSegue(withIdentifier: "home", sender: nil)
                    }else{
                        var style = ToastStyle()
                        
                        // this is just one of many style options
                        style.messageColor = .white
                        self.view.makeToast(swiftyJsonVar["response"]["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                        self.loaderEnd()
                    }
                   }
                   
                  
               }
    }
    
    
    //-----------dismiss keyboard on touching anywhere in the screen code starts-----------
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //-----------dismiss keyboard code ends-----------
    
    //============keyboard will show/hide, code starts==========
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    //============keyboard will show/hide, code ends===========
    
    // ====================== Blur Effect Defiend START ================= \\
    var ActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var blurEffectView: UIVisualEffectView!
    var loader: UIVisualEffectView!
    func loaderStart() {
        // ====================== Blur Effect START ================= \\
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        loader = UIVisualEffectView(effect: blurEffect)
        loader.frame = view.bounds
        loader.alpha = 2
        view.addSubview(loader)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2, y: 2)
        ActivityIndicator.transform = transform
        loadingIndicator.center = self.view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.white
        loadingIndicator.startAnimating();
        loader.contentView.addSubview(loadingIndicator)
        
        // screen roted and size resize automatic
        loader.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
        
        // ====================== Blur Effect END ================= \\
    }
    
    func loaderEnd() {
        self.loader.removeFromSuperview();
    }
    // ====================== Blur Effect Defiend END ================= \\
    
    // ====================== Blur Effect function calling code starts ================= \\
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.7
        view.addSubview(blurEffectView)
        // screen roted and size resize automatic
        blurEffectView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
        
    }
    func canelBlurEffect() {
        self.blurEffectView.removeFromSuperview();
    }
    // ====================== Blur Effect function calling code ends =================
    

}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


