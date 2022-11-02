//
//  CompanyInformationVC.swift
//  MySunless
//
//  Created by iMac on 04/12/21.
//

import UIKit
import Alamofire
import iOSDropDown
import Kingfisher

class CompanyInformationVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_companyName: UIView!
    @IBOutlet var txtCompanyName: UITextField!
    @IBOutlet var vw_phoneNumber: UIView!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var vw_localSalesTaxRate: UIView!
    @IBOutlet var vw_leadingLocalSalesTaxRate: UIView!
    @IBOutlet var vw_trailingLocalSalesTaxRate: UIView!
    @IBOutlet var txtLocalSalesTaxRate: UITextField!
    @IBOutlet var vw_companyLogo: UIView!
    @IBOutlet var imgCompanyLogo: UIImageView!
    @IBOutlet var vw_country: UIView!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var vw_state: UIView!
    @IBOutlet var txtState: DropDown!
    @IBOutlet var vw_city: UIView!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var vw_zip: UIView!
    @IBOutlet var txtZip: UITextField!
    @IBOutlet var vw_address: UIView!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var imgQRCode: UIImageView!
    @IBOutlet var vw_bookingLink: UIView!
    @IBOutlet var txtBookingLink: UITextField!
    @IBOutlet var vw_bookingEndPointURL: UIView!
    @IBOutlet var txtBookingEndPointURL: UITextField!
    @IBOutlet var vw_customerInstructions: UIView!
    @IBOutlet var txtVwCustomerInstructions: UITextView!
    @IBOutlet var txtVwImportant: UITextView!
    //https://new.mysunless.com/crm/Book-now?ref=Mzg=
    //MARK:- Variable Declarations
    var token = String()
    let imagePicker = UIImagePickerController()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtBookingLink.text = "https://new.mysunless.com/crm/Book-now?ref=Mzg="
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        setInitially()
        hideKeyboardWhenTappedAround()
        callShowCompanyAPI()

    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_companyName.layer.borderWidth = 0.5
        vw_companyName.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_phoneNumber.layer.borderWidth = 0.5
        vw_phoneNumber.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_localSalesTaxRate.layer.borderWidth = 0.5
        vw_localSalesTaxRate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_companyLogo.layer.borderWidth = 0.5
        vw_companyLogo.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_country.layer.borderWidth = 0.5
        vw_country.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_state.layer.borderWidth = 0.5
        vw_state.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_city.layer.borderWidth = 0.5
        vw_city.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_zip.layer.borderWidth = 0.5
        vw_zip.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_address.layer.borderWidth = 0.5
        vw_address.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_bookingLink.layer.borderWidth = 0.5
        vw_bookingLink.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_bookingEndPointURL.layer.borderWidth = 0.5
        vw_bookingEndPointURL.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_customerInstructions.layer.borderWidth = 0.5
        vw_customerInstructions.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
        imgCompanyLogo.layer.cornerRadius = 12
        txtCompanyName.delegate = self
        txtPhoneNumber.delegate = self
        txtEmail.delegate = self
        txtState.delegate = self
        txtZip.delegate = self
        txtAddress.delegate = self
        txtBookingEndPointURL.delegate = self
        txtVwCustomerInstructions.delegate = self
        
        let attributedString = NSMutableAttributedString.init(string: txtVwImportant.text)
        let range = (txtVwImportant.text as NSString).range(of: "Important:")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init("#005CC8"), range: range)
        let range1 = (txtVwImportant.text as NSString).range(of: "Click here.")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init("#15B0DA"), range: range1)
        txtVwImportant.attributedText = attributedString
        txtVwImportant.font = UIFont(name: "Roboto-Regular", size: 17)
        txtVwImportant.textAlignment = .justified
        txtVwImportant.isUserInteractionEnabled = true
        txtVwImportant.isEditable = false
        
        txtState.optionArray = stateList
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse(recognizer:)))
        tapGesture.numberOfTapsRequired = 1
        txtVwImportant.addGestureRecognizer(tapGesture)
        
    }
    
    func validation() -> Bool {
        if txtCompanyName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter company name", viewController: self)
        } else if txtPhoneNumber.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter phone number", viewController: self)
        } else if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter email", viewController: self)
        } else if txtLocalSalesTaxRate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter sales tax", viewController: self)
        } else if txtCountry.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter country", viewController: self)
        } else if txtState.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter state", viewController: self)
        } else if txtCity.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter city", viewController: self)
        } else if txtZip.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter zip", viewController: self)
        } else if txtAddress.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter address", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callShowCompanyAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        APIUtilities.sharedInstance.GetDictAPICallWith(url: BASE_URL + SHOW_COMPANY, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let CompanyName = res.value(forKey: "CompanyName") as? String {
                    self.txtCompanyName.text = CompanyName
                }
                if let Phone = res.value(forKey: "Phone") as? String {
                    self.txtPhoneNumber.text = Phone
                }
                if let email = res.value(forKey: "email") as? String {
                    self.txtEmail.text = email
                }
                if let sales_tax = res.value(forKey: "sales_tax") as? String {
                    self.txtLocalSalesTaxRate.text = sales_tax
                }
                if let compimg = res.value(forKey: "compimg") as? String {
                    let imgUrl = URL(string: compimg)
                    self.imgCompanyLogo.kf.setImage(with: imgUrl)
                }
                if let Country = res.value(forKey: "Country") as? String {
                    self.txtCountry.text = Country
                }
                if let State = res.value(forKey: "State") as? String {
                    self.txtState.text = State
                }
                if let City = res.value(forKey: "City") as? String {
                    self.txtCity.text = City
                }
                if let Zip = res.value(forKey: "Zip") as? String {
                    self.txtZip.text = Zip
                }
                if let Address = res.value(forKey: "Address") as? String {
                    self.txtAddress.text = Address
                }
                if let qr_image = res.value(forKey: "qr_image") as? String {
                    let qr_imgUrl = URL(string: qr_image)
                    self.imgQRCode.kf.setImage(with: qr_imgUrl)
                }
                if let booking_endpoint = res.value(forKey: "booking_endpoint") as? String {
                    self.txtBookingEndPointURL.text = booking_endpoint
                }
                if let customer_instruction = res.value(forKey: "customer_instruction") as? String {
                    self.txtVwCustomerInstructions.text = customer_instruction
                }
            }
        }
    }
    
    func callUpdateCompanyAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [ "name": txtCompanyName.text ?? "",
                   "phone": txtPhoneNumber.text ?? "",
                   "email": txtEmail.text ?? "",
                   "taxrate": txtLocalSalesTaxRate.text ?? "",
                   "state": txtState.text ?? "",
                   "city": txtCity.text ?? "",
                   "zip": txtZip.text ?? "",
                   "address": txtAddress.text ?? "",
                   "endpointurl": txtBookingEndPointURL.text ?? "",
                   "customerinstruction": txtVwCustomerInstructions.text ?? ""
        ]
        let comImg: UIImage = imgCompanyLogo.image ?? UIImage()
        let imageData = comImg.pngData()
        
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + UPDATE_COMPANY, keyName: "companyimage", imageData: imageData, param: params, header: headers) { (response, error) in
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

    //MARK:- Actions
    @IBAction func btnSelectImageClick(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnCopyClick(_ sender: UIButton) {
        UIPasteboard.general.string = txtBookingLink.text
        AppData.sharedInstance.showAlert(title: "URL Copied", message: txtBookingLink.text ?? "", viewController: self)
    }
    
    @IBAction func btnSetHoursClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WorkingHoursVC") as! WorkingHoursVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnUpdateComInfoClick(_ sender: UIButton) {
        if self.validation() {
            callUpdateCompanyAPI()
        }
    }
    
    @objc func tapResponse(recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: txtVwImportant)
        let position: CGPoint = CGPoint(x: location.x, y: location.y)
        let tapPosition: UITextPosition? = txtVwImportant.closestPosition(to: position)
        if tapPosition != nil {
            let textRange: UITextRange? = txtVwImportant.tokenizer.rangeEnclosingPosition(tapPosition!, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))
            if textRange != nil {
                let tappedWord: String? = txtVwImportant.text(in: textRange!)
                if (tappedWord == "Click" || tappedWord == "here") {
                    //  print("tapped word : ", tappedWord ?? "")
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ManageEmployeeVC") as! ManageEmployeeVC
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
}

//MARK:- ImagePickerController Delegate Methods
extension CompanyInformationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgCompanyLogo.contentMode = .scaleAspectFill
            imgCompanyLogo.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgCompanyLogo.contentMode = .scaleAspectFill
            imgCompanyLogo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

extension CompanyInformationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCompanyName.resignFirstResponder()
        txtPhoneNumber.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtLocalSalesTaxRate.resignFirstResponder()
        txtCountry.resignFirstResponder()
        txtState.resignFirstResponder()
        txtCity.resignFirstResponder()
        txtZip.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtBookingEndPointURL.resignFirstResponder()
        return false
    }
}

extension CompanyInformationVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        txtVwCustomerInstructions.resignFirstResponder()
    }
}
