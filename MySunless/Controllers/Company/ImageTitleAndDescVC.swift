//
//  ImageTitleAndDescVC.swift
//  MySunless
//
//  Created by Daydream Soft on 07/03/22.
//

import UIKit
import Alamofire

class ImageTitleAndDescVC: UIViewController {
    
    @IBOutlet var vw_title: UIView!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var vw_description: UIView!
    @IBOutlet var txtVwDescription: UITextView!
   
    var token = String()
    var isForEdit = false
    var gallaryImageList = ShowGallaryImageList(dict:[:])
    var placeholder = "Enter text..."
    var selectedID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        self.hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gallaryImageList.description == "" {
            txtVwDescription.text = placeholder
            txtVwDescription.textColor = .lightGray
        } else {
            txtVwDescription.text = gallaryImageList.description
            txtVwDescription.textColor = .black
        }
        txtTitle.text = gallaryImageList.title
    }
    
    func setInitially() {
        vw_title.layer.borderWidth = 0.5
        vw_title.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_description.layer.borderWidth = 0.5
        vw_description.layer.borderColor = UIColor.init("15B0DA").cgColor
        txtVwDescription.delegate = self
    }
    
    func callUpdateGallaryImageListAPI() {
        AppData.sharedInstance.showLoader()
        let headers:HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["title": txtTitle.text ?? "",
                  "description": txtVwDescription.text ?? ""
        ]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + UPDATE_GALLARYIMAGE_LIST + "\(selectedID)", param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
       callUpdateGallaryImageListAPI()
    }

}

//MARK:- Textfield Delegate Methods
extension ImageTitleAndDescVC: UITextFieldDelegate {
    
}

//MARK:- TextView Delegate Methods
extension ImageTitleAndDescVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVwDescription.textColor == .lightGray {
            txtVwDescription.text = ""
            txtVwDescription.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtVwDescription.text.isEmpty {
            txtVwDescription.text = "Enter text..."
            txtVwDescription.textColor = UIColor.lightGray
            placeholder = ""
        } else {
            placeholder = txtVwDescription.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder = txtVwDescription.text
    }
}

