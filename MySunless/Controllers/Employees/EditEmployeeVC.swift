//
//  EditEmployeeVC.swift
//  MySunless
//
//  Created by iMac on 07/12/21.
//

import UIKit
import Alamofire
import Kingfisher

class EditEmployeeVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var btnPersonalInfo: UIButton!
    @IBOutlet var vw_personalInfo: UIView!
    @IBOutlet var vw_username: UIView!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var btnRefreshUsername: UIButton!
    @IBOutlet var vw_firstname: UIView!
    @IBOutlet var txtFirstname: UITextField!
    @IBOutlet var vw_lastname: UIView!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var vw_phoneNumber: UIView!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var btnAvatar: UIButton!
    @IBOutlet var vw_avatar: UIView!
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var btnAvatarImg: UIButton!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var vw_changePassword: UIView!
    @IBOutlet var vw_newPassword: UIView!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var vw_confirmNewPassword: UIView!
    @IBOutlet var txtConfirmNewPassword: UITextField!
    
    //MARK:- Variable Declarations
    var token = String()
    var employeeId = Int()
    let imagePicker = UIImagePickerController()
    var empImg = UIImage()
    var imgStr = String()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        self.hideKeyboardWhenTappedAround()
        callEmployeeDataAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if imgAvatar.image == nil {
            imgAvatar.image = UIImage(named: "image-placeholder")
        }
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        btnPersonalInfo.layer.borderWidth = 1
        btnPersonalInfo.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnAvatar.layer.borderWidth = 1
        btnAvatar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnChangePassword.layer.borderWidth = 1
        btnChangePassword.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
        vw_personalInfo.layer.cornerRadius = 12
        vw_personalInfo.layer.masksToBounds = true
        vw_personalInfo.backgroundColor = UIColor.white
        vw_personalInfo.layer.shadowColor = UIColor.lightGray.cgColor
        vw_personalInfo.layer.shadowOpacity = 0.1
        vw_personalInfo.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_personalInfo.layer.shadowRadius = 6.0
        vw_personalInfo.layer.masksToBounds = false
        
        vw_avatar.layer.cornerRadius = 12
        vw_avatar.layer.masksToBounds = true
        vw_avatar.backgroundColor = UIColor.white
        vw_avatar.layer.shadowColor = UIColor.lightGray.cgColor
        vw_avatar.layer.shadowOpacity = 0.1
        vw_avatar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_avatar.layer.shadowRadius = 6.0
        vw_avatar.layer.masksToBounds = false
        
        vw_changePassword.layer.cornerRadius = 12
        vw_changePassword.layer.masksToBounds = true
        vw_changePassword.backgroundColor = UIColor.white
        vw_changePassword.layer.shadowColor = UIColor.lightGray.cgColor
        vw_changePassword.layer.shadowOpacity = 0.1
        vw_changePassword.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_changePassword.layer.shadowRadius = 6.0
        vw_changePassword.layer.masksToBounds = false
        
        vw_username.layer.borderWidth = 0.5
        vw_username.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_firstname.layer.borderWidth = 0.5
        vw_firstname.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_lastname.layer.borderWidth = 0.5
        vw_lastname.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_phoneNumber.layer.borderWidth = 0.5
        vw_phoneNumber.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_newPassword.layer.borderWidth = 0.5
        vw_newPassword.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_confirmNewPassword.layer.borderWidth = 0.5
        vw_confirmNewPassword.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnRefreshUsername.roundCorners(corners: [.topRight, .bottomRight], radius: 8.0)
        imgAvatar.layer.cornerRadius = 12
    }
    
    func validation() -> Bool {
        if txtUsername.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Username", viewController: self)
        } else if txtFirstname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Email", viewController: self)
        } else if txtPhoneNumber.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Phonenumber", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func refreshUsernameValidation() -> Bool {
        if txtFirstname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callEmployeeDataAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["employee_id" : employeeId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_EMPLOYEE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let username = res.value(forKey: "username") {
                    self.txtUsername.text = username as? String ?? ""
                }
                if let firstname = res.value(forKey: "firstname") {
                    self.txtFirstname.text = firstname as? String ?? ""
                }
                if let lastname = res.value(forKey: "lastname") {
                    self.txtLastname.text = lastname as? String ?? ""
                }
                if let email = res.value(forKey: "email") {
                    self.txtEmail.text = email as? String ?? ""
                }
                if let phonenumber = res.value(forKey: "phonenumber") {
                    self.txtPhoneNumber.text = phonenumber as? String ?? ""
                }
                if let userimg = res.value(forKey: "user_image") {
                    let url = URL(string: userimg as? String ?? "")
                    self.imgAvatar.kf.setImage(with: url)
                }
                
                
            }
        }
        
    }
    
    func callUpdateEmployeeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        var params = NSDictionary()
        params = [
            "employee_id" : employeeId,
            "user_name" : txtUsername.text ?? "",
            "first_name" : txtFirstname.text ?? "",
            "last_name" : txtLastname.text ?? "",
            "email" : txtEmail.text ?? "",
            "phone_no" : txtPhoneNumber.text ?? ""
        ]
        let empImg: UIImage = imgAvatar.image ?? UIImage()
        let imageData = empImg.pngData()
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + UPDATE_EMPLOYEE, keyName: "emp_img", imageData: imageData, param: params, header: headers) { (response, error) in
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
    
    func callSetUsernameAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "firstname" : txtFirstname.text ?? "",
            "lastname" : txtLastname.text ?? ""
        ]
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + SET_USERNAME, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let userName = res.value(forKey: "username") as? String {
                            //  print(userName)
                            self.txtUsername.text = userName
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
    
    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPersonalInfoClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnRefreshUsernameClick(_ sender: UIButton) {
        if (self.refreshUsernameValidation()) {
            callSetUsernameAPI()
        }
    }
    
    @IBAction func btnAvatarClick(_ sender: UIButton) {
    }
    
    @IBAction func btnAvatarImgClick(_ sender: UIButton) {
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnUploadImgClick(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
//        if imgAvatar.image != nil {
//            AppData.sharedInstance.showAlert(title: "", message: "Image Successfully Uploaded", viewController: self)
//        } else {
//            AppData.sharedInstance.showAlert(title: "", message: "Please Upload Image", viewController: self)
//        }
        
    }
    
    @IBAction func btnChangePasswordClick(_ sender: UIButton) {
    }

    @IBAction func btnUpdatePasswordClick(_ sender: UIButton) {
    }
    
    @IBAction func btnSubmitEmployeeClick(_ sender: UIButton) {
        if (self.validation()) {
            callUpdateEmployeeAPI()
        }
    }
    
    @IBAction func btnCancelEmployeeClick(_ sender: UIButton) {
    }
    
}

//MARK:- ImagePickerController Delegate Methods
extension EditEmployeeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
