//
//  LtaSupportingDocumentsPdfViewerViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 22/07/21.
//

import UIKit
import WebKit
import Toast_Swift

class LtaSupportingDocumentsPdfViewerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var ImagePrintPdf: UIImageView!
    var modifiedStringHtml: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        if let decodeData = NSData(base64Encoded: LtaSupportingDocumentsViewController.DocumentBase64String, options: .ignoreUnknownCharacters) {
            webView.load(decodeData as Data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: NSURL(fileURLWithPath: "") as URL)
        }
        //------PrintPdf
        let tapGestureRecognizerImagePrintPdf = UITapGestureRecognizer(target: self, action: #selector(ImagePrintPdf(tapGestureRecognizer:)))
        ImagePrintPdf.isUserInteractionEnabled = true
        ImagePrintPdf.addGestureRecognizer(tapGestureRecognizerImagePrintPdf)
    }
    

    @IBAction func BtnBack(_ sender: Any) {
//        self.performSegue(withIdentifier: "supportingdoc", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    //---PrintPdf
    @objc func ImagePrintPdf(tapGestureRecognizer: UITapGestureRecognizer){
//        savePdf(html: modifiedStringHtml, formmatter: webView.viewPrintFormatter(), filename: LtaSupportingDocumentsViewController.FileName)
        let pdfFilePath = self.webView.exportAsPdfFromWebView(FileName: LtaSupportingDocumentsViewController.FileName)
        print(pdfFilePath)
        
    }
    //------function to save in pdf mode from WebView, starts
    /*  func savePdf(html: String, formmatter: UIViewPrintFormatter, filename: String) {
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
          }*/
      //------function to save in pdf mode from WebView, ends

}
extension WKWebView {
    
    // Call this function when WKWebView finish loading
    func exportAsPdfFromWebView(FileName: String) -> String {
        let pdfData = createPdfFile(printFormatter: self.viewPrintFormatter())
        return self.saveWebViewPdf(data: pdfData, FileName: FileName)
    }
    
    func createPdfFile(printFormatter: UIViewPrintFormatter) -> NSMutableData {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x: originalBounds.origin.x, y: bounds.origin.y, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        printPageRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pdfPageFrame), forKey: "printableRect")
        self.bounds = originalBounds
        return printPageRenderer.generatePdfData()
    }
    
    // Save pdf file in document directory
    func saveWebViewPdf(data: NSMutableData, FileName: String) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent(FileName)
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}

extension UIPrintPageRenderer {
    
    func generatePdfData() -> NSMutableData {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()
        for pdfPage in 0..<self.numberOfPages {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }
        UIGraphicsEndPDFContext();
        return pdfData
    }
}
