//
//  PersonalInfoVC.swift
//  MySunless
//
//  Created by iMac on 12/10/21.
//

import UIKit
import iOSDropDown

class PersonalInfoVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_Main: UIView!
    @IBOutlet var vw_firstName: UIView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var vw_lastName: UIView!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var vw_userName: UIView!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var vw_phoneNumber: UIView!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var vw_primaryAddress: UIView!
    @IBOutlet var txtVwPrimaryAddress: UITextView!
    @IBOutlet var vw_country: UIView!
    @IBOutlet var vw_state: UIView!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var vw_city: UIView!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var vw_zipcode: UIView!
    @IBOutlet var txtZipcode: UITextField!
    @IBOutlet var vw_profileImage: UIView!
    @IBOutlet var vw_dropDown: UIView!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblZipcode: UILabel!
    @IBOutlet var imgDropdown: UIImageView!
    @IBOutlet var dropdownTblview: UITableView!
    @IBOutlet var vw_searchbar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var vw_profileImagTopConstraint: NSLayoutConstraint!
    @IBOutlet var btnRefreshUsername: UIButton!
    @IBOutlet var profileImgview: UIImageView!
    
    //MARK:- Variable Declarations
    var dropdownOpen = true
    var arrData = [String]()
    
    var searchedCountry = [String]()
    var searching = false
    
    var selected: String?
    let imagePicker = UIImagePickerController()
    var dict = [String:Any]()
    var lblPlaceHolder : UILabel!
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_Main.layer.cornerRadius = 12
        vw_Main.layer.masksToBounds = true
        
        vw_Main.backgroundColor = UIColor.white
        vw_Main.layer.shadowColor = UIColor.lightGray.cgColor
        vw_Main.layer.shadowOpacity = 0.8
        vw_Main.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_Main.layer.shadowRadius = 6.0
        vw_Main.layer.masksToBounds = false
        
        vw_firstName.layer.borderWidth = 0.5
        vw_firstName.layer.borderColor = UIColor.gray.cgColor
        vw_lastName.layer.borderWidth = 0.5
        vw_lastName.layer.borderColor = UIColor.gray.cgColor
        vw_userName.layer.borderWidth = 0.5
        vw_userName.layer.borderColor = UIColor.gray.cgColor
        vw_phoneNumber.layer.borderWidth = 0.5
        vw_phoneNumber.layer.borderColor = UIColor.gray.cgColor
        vw_primaryAddress.layer.borderWidth = 0.5
        vw_primaryAddress.layer.borderColor = UIColor.gray.cgColor
        vw_country.layer.borderWidth = 0.5
        vw_country.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_state.layer.borderWidth = 0.5
        vw_state.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_city.layer.borderWidth = 0.5
        vw_city.layer.borderColor = UIColor.gray.cgColor
        vw_zipcode.layer.borderWidth = 0.5
        vw_zipcode.layer.borderColor = UIColor.gray.cgColor
        vw_profileImage.layer.borderWidth = 0.5
        vw_profileImage.layer.borderColor = UIColor.gray.cgColor
        
        vw_dropDown.layer.borderWidth = 0.5
        vw_dropDown.layer.borderColor = UIColor.gray.cgColor
        
        vw_searchbar.layer.borderWidth = 0.5
        vw_searchbar.layer.borderColor = UIColor.gray.cgColor
        
        btnRefreshUsername.roundCorners(corners: [.topRight, .bottomRight], radius: 8.0)
        
        vw_dropDown.isHidden = true
        searchBar.delegate = self
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtUserName.delegate = self
        txtPhoneNumber.delegate = self
        txtVwPrimaryAddress.delegate = self
        txtCity.delegate = self
        txtZipcode.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        profileImgview.layer.cornerRadius = 12
        
        arrData = stateList
        
        txtUserName.text = UserDefaults.standard.value(forKey: "username") as? String ?? ""
        
        lblPlaceHolder = UILabel()
        lblPlaceHolder.text = "Enter Primary Address"
        //  lblPlaceHolder.font = UIFont.systemFont(ofSize: txtVwAppointmentInst.font!.pointSize)
        lblPlaceHolder.font = UIFont(name: "Roboto-Regular", size: 17)
        lblPlaceHolder.sizeToFit()
        lblPlaceHolder.numberOfLines = 0
        txtVwPrimaryAddress.addSubview(lblPlaceHolder)
        lblPlaceHolder.frame.origin = CGPoint(x: 0, y: 5)
      //  lblPlaceHolder.frame.size = CGSize(width: txtVwPrimaryAddress.frame.size.width, height: txtVwPrimaryAddress.frame.size.height)
        lblPlaceHolder.textColor = UIColor.init("#C4C4C6")
        lblPlaceHolder.isHidden = !txtVwPrimaryAddress.text.isEmpty
        
        setTxtVwToolbar()
    }
    
    //MARK:- User-Defined Functions
    func setTxtVwToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        ]
        txtVwPrimaryAddress.inputAccessoryView = toolbar
    }
    
    func validation() -> Bool {
        if txtFirstName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else if txtPhoneNumber.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Phonenumber", viewController: self)
        } else if txtVwPrimaryAddress.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Address", viewController: self)
        } else if txtState.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter State", viewController: self)
        } else if txtCity.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter City", viewController: self)
        } else if txtZipcode.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Zipcode", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callSetUsernameAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "firstname" : txtFirstName.text ?? "",
            "lastname" : txtLastName.text ?? ""
        ]
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + SET_USERNAME, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let userName = res.value(forKey: "username") as? String {
                          //  print(userName)
                            self.txtUserName.text = userName
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
    @IBAction func btnRefreshUsernameClick(_ sender: UIButton) {
        if (txtFirstName.text == "" || txtLastName.text == "") {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Firstname and Lastname require for generating the Username", viewController: self)
        } else {
            callSetUsernameAPI()
        }
    }
    
    @IBAction func btnSelectImg(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        if (self.validation()) {
            let imageData = (profileImgview.image ?? UIImage()).pngData()

            UserDefaults.standard.setValue(txtFirstName.text ?? "", forKey: "firstname")
            UserDefaults.standard.setValue(txtLastName.text ?? "", forKey: "lastname")
            UserDefaults.standard.setValue(txtUserName.text ?? "", forKey: "username")
            UserDefaults.standard.setValue(txtPhoneNumber.text ?? "", forKey: "user_phone_number")
            UserDefaults.standard.setValue(txtVwPrimaryAddress.text ?? "", forKey: "user_primary_address")
            UserDefaults.standard.setValue(txtState.text ?? "", forKey: "user_state")
            UserDefaults.standard.setValue(txtCity.text ?? "", forKey: "user_city")
            UserDefaults.standard.setValue(txtZipcode.text ?? "", forKey: "user_zipcode")
            UserDefaults.standard.set(imageData, forKey: "userimage")

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyInfoVC") as! CompanyInfoVC
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyInfoVC") as! CompanyInfoVC
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnDropdown(_ sender: UIButton) {
       showHideDropDown()
    }
    
    @objc func doneAction(){
        self.txtVwPrimaryAddress.resignFirstResponder()
    }
    
    func showHideDropDown() {
        if (dropdownOpen == true) {
            self.vw_dropDown.isHidden = false
            imgDropdown.image = UIImage(named: "up-arrow")
            vw_profileImagTopConstraint.constant = 100
            
            vw_city.isHidden = true
            vw_zipcode.isHidden = true
            lblCity.isHidden = true
            lblZipcode.isHidden = true
            
            dropdownOpen = false
        } else {
            self.vw_dropDown.isHidden = true
            imgDropdown.image = UIImage(named: "down-arrow-1")
            vw_profileImagTopConstraint.constant = 15
            
            vw_city.isHidden = false
            vw_zipcode.isHidden = false
            lblCity.isHidden = false
            lblZipcode.isHidden = false
            
            dropdownOpen = true
        
        }
    }
}

extension PersonalInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return arrData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dropdownTblview.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        if searching {
            cell.lblName.text = searchedCountry[indexPath.row]
        } else {
            cell.lblName.text = arrData[indexPath.row]
        }
        return cell
    }
    
}

extension PersonalInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = dropdownTblview.cellForRow(at: indexPath) as! DropdownCell
        txtState.text = cell.lblName.text
        
        if searching {
            let selectedCountry = searchedCountry[indexPath.row]
            selected = selectedCountry
        } else {
            let selectedCountry = arrData[indexPath.row]
            selected = selectedCountry
        }
        
        self.searchBar.searchTextField.endEditing(true)
        showHideDropDown()
      //  dropdownTblview.deselectRow(at: indexPath, animated: true)
    }
    
}

extension PersonalInfoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = arrData.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        dropdownTblview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        dropdownTblview.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension PersonalInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImgview.contentMode = .scaleAspectFill
            profileImgview.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImgview.contentMode = .scaleAspectFill
            profileImgview.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

//MARK:- Textfield Delegate Methods
extension PersonalInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtUserName.resignFirstResponder()
        txtPhoneNumber.resignFirstResponder()
      //  txtPrimaryAddress.resignFirstResponder()
        txtCity.resignFirstResponder()
        txtZipcode.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            case txtPhoneNumber:
                let text = txtPhoneNumber.text
                txtPhoneNumber.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
                return AppData.sharedInstance.textLimitForPhone(existingText: txtPhoneNumber.text, newText: string, limit: 14)
            default:
                return true
        }
    }
}

extension PersonalInfoVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.txtVwPrimaryAddress.endEditing(true)
        txtVwPrimaryAddress.resignFirstResponder()
    }
}

