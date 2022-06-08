//
//  ChangeAvatarVC.swift
//  MySunless
//
//  Created by Daydream Soft on 08/06/22.
//

import UIKit
import Alamofire

class ChangeAvatarVC: UIViewController {
    
    @IBOutlet var btnSelectImageClick: UIButton!
    @IBOutlet var imgAvatar: UIImageView!
    
    var token = String()
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imgAvatar.layer.cornerRadius = 12
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetProfileAPI()
    }
    
    func callGetProfileAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        
        APIUtilities.sharedInstance.GetDictAPICallWith(url: BASE_URL + USER_PROFILE, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let user_image = res.value(forKey: "user_image") as? String {
                    let userImgUrl = URL(string: user_image)
                    self.imgAvatar.kf.setImage(with: userImgUrl)
                }
            }
        }
    }
    
    func callChangeAvatarAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        let imgAvataar: UIImage = imgAvatar.image ?? UIImage()
        let imageData = imgAvataar.pngData()
        
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + USER_AVATAR, keyName: "profileimage", imageData: imageData, param: [:], header: headers) { (response, error) in
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
    
    @IBAction func btnSelectImageClick(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnUploadImageClick(_ sender: UIButton) {
        callChangeAvatarAPI()
    }
    
}

extension ChangeAvatarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgAvatar.contentMode = .scaleAspectFill
            imgAvatar.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
