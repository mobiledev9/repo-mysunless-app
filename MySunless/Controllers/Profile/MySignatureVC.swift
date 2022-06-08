//
//  MySignatureVC.swift
//  MySunless
//
//  Created by Daydream Soft on 08/06/22.
//

import UIKit
import SwiftSignatureView
import Alamofire

class MySignatureVC: UIViewController {
    
    @IBOutlet var signatureView: SwiftSignatureView!
    @IBOutlet var showSignatureView: UIImageView!
    @IBOutlet var btnRemoveSignature: UIButton!
    
    var token = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setInitially() {
        signatureView.layer.borderColor = UIColor.init("005CC8").cgColor
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.cornerRadius = 8
        
        showSignatureView.layer.borderColor = UIColor.init("005CC8").cgColor
        showSignatureView.layer.borderWidth = 0.5
        signatureView.delegate = self
    }
    
    func callSaveSignatureAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        
        let signatureImage: UIImage = showSignatureView.image ?? UIImage()
        let imageData = signatureImage.pngData()
        
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + SAVE_SIGNATURE, keyName: "signature",imageData: imageData, param: [:], header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnSaveSignatureClick(_ sender: UIButton) {
        showSignatureView.image = signatureView.getCroppedSignature()
        if showSignatureView.image == nil {
            btnRemoveSignature.isHidden = true
        } else {
            btnRemoveSignature.isHidden = false
        }
        signatureView.clear()
        print("fullRender \(showSignatureView.image?.size ?? CGSize.zero)")
        
        callSaveSignatureAPI()
    }
    
    @IBAction func btnClearSignatureClick(_ sender: UIButton) {
        signatureView.clear()
    }
    
    @IBAction func btnRemoveSignatureClick(_ sender: UIButton) {
        showSignatureView.image = nil
    }

}

extension MySignatureVC: SwiftSignatureViewDelegate {
    func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {
        print("swiftSignatureViewDidDrawGesture")
      //  scrollView.panGestureRecognizer.require(toFail: tap)
    
    }
    
    func swiftSignatureViewDidDraw(_ view: ISignatureView) {
        print("swiftSignatureViewDidDraw")
      
    }
}
