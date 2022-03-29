//
//  SalarySlipPdfViewController.swift
//  WrkplanPayroll
//
//  Created by Debashis Pal on 29/03/22.
//

import UIKit
import WebKit
import Toast_Swift

class SalarySlipPdfViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var ImagePrintPdf: UIImageView!
    let htmlstring = DashboardViewController.report_html!
    static var modifiedStringHtml: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChangeStatusBarColor() //---to change background statusbar color

        // Do any additional setup after loading the view.
        SalarySlipPdfViewController.modifiedStringHtml  = htmlstring.replacingOccurrences(of: "file:///android_asset/pflogo.png", with: HtmlImageBase64String)
       
        webView.loadHTMLString(SalarySlipPdfViewController.modifiedStringHtml, baseURL: nil)
        
        //------PrintPdf
        let tapGestureRecognizerImagePrintPdf = UITapGestureRecognizer(target: self, action: #selector(ImagePrintPdf(tapGestureRecognizer:)))
        ImagePrintPdf.isUserInteractionEnabled = true
        ImagePrintPdf.addGestureRecognizer(tapGestureRecognizerImagePrintPdf)
    }
    

    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "dboard", sender: nil)
    }
    
    //---PrintPdf
    @objc func ImagePrintPdf(tapGestureRecognizer: UITapGestureRecognizer){
        savePdf(html: SalarySlipPdfViewController.modifiedStringHtml, formmatter: webView.viewPrintFormatter(), filename: DashboardViewController.year)
        
    }
    
    //------function to save in pdf mode from WebView, starts
      func savePdf(html: String, formmatter: UIViewPrintFormatter, filename: String) {
              DispatchQueue.main.async {
                  // 2. Assign print formatter to UIPrintPageRenderer
                  let render = UIPrintPageRenderer()
                  render.addPrintFormatter(formmatter, startingAtPageAt: 0)

                  // 3. Assign paperRect and printableRect
                  let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
                  let printable = page.insetBy(dx: 0, dy: 0)

                  render.setValue(NSValue(cgRect: page), forKey: "paperRect")
                  render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

                  // 4. Create PDF context and draw
                  let pdfData = NSMutableData()
                  UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)

                  for i in 1...render.numberOfPages {

                      UIGraphicsBeginPDFPage();
                      let bounds = UIGraphicsGetPDFContextBounds()
                      render.drawPage(at: i - 1, in: bounds)
                  }

                  UIGraphicsEndPDFContext();

                  let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                  let pdfNameFromUrl = "WrkplanPayrollPFReport-\(filename).pdf"
                  let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                  do {
                      try pdfData.write(to: actualPath, options: .atomic)
                      print("pdf successfully saved!")
                      print("Path-=>",actualPath)
                     
                      var style = ToastStyle()
                      
                      // this is just one of many style options
                      style.messageColor = .white
                      self.view.makeToast("Pdf successfully saved!", duration: 3.0, position: .bottom, style: style)
                  } catch {
                      print("Pdf could not be saved")
                      
                      var style = ToastStyle()
                      
                      // this is just one of many style options
                      style.messageColor = .white
                      self.view.makeToast("Pdf could not be saved", duration: 3.0, position: .bottom, style: style)
                  }
              }
          }
      //------function to save in pdf mode from WebView, ends
}
