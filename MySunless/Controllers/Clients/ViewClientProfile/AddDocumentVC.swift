//
//  AddDocumentVC.swift
//  MySunless
//
//  Created by Daydream Soft on 25/03/22.
//

import UIKit
import Alamofire

class AddDocumentVC: UIViewController {
    
    @IBOutlet var vw_fileName: UIView!
    @IBOutlet var txtFileName: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    
    let imagePicker = UIImagePickerController()
    var selectedClientId = Int()
    var token = String()
    var delegate: AddDocumentProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    func setInitially() {
        vw_fileName.layer.borderWidth = 0.5
        vw_fileName.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_fileName.layer.cornerRadius = 12
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        vw_bottom.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        imageView.layer.cornerRadius = 12
    }
    
    func validation() -> Bool {
        if txtFileName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter filename", viewController: self)
        } else if (imageView.image == nil) {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please add valid file", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callUploadDocumentAPI(clientId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["clientid": clientId,
                  "filename": txtFileName.text ?? ""
        ]
        let img: UIImage = imageView.image ?? UIImage()
        let imageData = img.pngData()
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + UPLOAD_DOCUMENT, keyName: "document", imageData: imageData, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if (success == "1") {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnSelectImageClick(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnUploadDoumentClick(_ sender: UIButton) {
        if validation() {
            callUploadDocumentAPI(clientId: selectedClientId)
        }
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.callShowDocumentAPI(clientId: self.selectedClientId)
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.callShowDocumentAPI(clientId: self.selectedClientId)
        }
    }
}

//MARK:- ImagePickerController Delegate Methods
extension AddDocumentVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
