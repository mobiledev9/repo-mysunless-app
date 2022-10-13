//
//  CompanyInfoVC.swift
//  MySunless
//
//  Created by iMac on 12/10/21.
//

import UIKit
import StepView

class CompanyInfoVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_Main: UIView!
    @IBOutlet var vw_companyName: UIView!
    @IBOutlet var txtCompanyName: UITextField!
    @IBOutlet var vw_companyPhone: UIView!
    @IBOutlet var txtCompanyPhone: UITextField!
    @IBOutlet var vw_address: UIView!
    @IBOutlet var txtVwAddress: UITextView!
    @IBOutlet var vw_country: UIView!
    @IBOutlet var vw_state: UIView!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var vw_companyCity: UIView!
    @IBOutlet var txtCompanyCity: UITextField!
    @IBOutlet var vw_companyZipcode: UIView!
    @IBOutlet var txtCompanyZipcode: UITextField!
    @IBOutlet var vw_profileImage: UIView!
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var imgDropdown: UIImageView!
    @IBOutlet var lblCompanyCity: UILabel!
    @IBOutlet var lblcompanyZipcode: UILabel!
    @IBOutlet var vw_profileImgTopConstraint: NSLayoutConstraint!
    @IBOutlet var vw_dropdown: UIView!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var dropDownTblview: UITableView!
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
        
        vw_companyName.layer.borderWidth = 0.5
        vw_companyName.layer.borderColor = UIColor.gray.cgColor
        vw_companyPhone.layer.borderWidth = 0.5
        vw_companyPhone.layer.borderColor = UIColor.gray.cgColor
        vw_address.layer.borderWidth = 0.5
        vw_address.layer.borderColor = UIColor.gray.cgColor
        vw_country.layer.borderWidth = 0.5
        vw_country.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_state.layer.borderWidth = 0.5
        vw_state.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_companyCity.layer.borderWidth = 0.5
        vw_companyCity.layer.borderColor = UIColor.gray.cgColor
        vw_companyZipcode.layer.borderWidth = 0.5
        vw_companyZipcode.layer.borderColor = UIColor.gray.cgColor
        vw_profileImage.layer.borderWidth = 0.5
        vw_profileImage.layer.borderColor = UIColor.gray.cgColor
        
        vw_dropdown.layer.borderWidth = 0.5
        vw_dropdown.layer.borderColor = UIColor.gray.cgColor
        
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.gray.cgColor
        
        vw_dropdown.isHidden = true
        searchBar.delegate = self
        
        txtCompanyName.delegate = self
        txtCompanyPhone.delegate = self
        txtVwAddress.delegate = self
        txtCompanyCity.delegate = self
        txtCompanyZipcode.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        profileImgview.layer.cornerRadius = 12
        
        arrData = stateList
        
        //Getting image from userdefaults
//        let imageData = UserDefaults.standard.data(forKey: "userimage")
//        let imageUs = UIImage.init(data: imageData!)
//        profileImgview.image = imageUs
        
        profileImgview.contentMode = .scaleAspectFit
        
        lblPlaceHolder = UILabel()
        lblPlaceHolder.text = "Enter Company Address"
        //  lblPlaceHolder.font = UIFont.systemFont(ofSize: txtVwAppointmentInst.font!.pointSize)
        lblPlaceHolder.font = UIFont(name: "Roboto-Regular", size: 17)
        lblPlaceHolder.sizeToFit()
        lblPlaceHolder.numberOfLines = 0
        txtVwAddress.addSubview(lblPlaceHolder)
        lblPlaceHolder.frame.origin = CGPoint(x: 0, y: 5)
      //  lblPlaceHolder.frame.size = CGSize(width: txtVwAddress.frame.size.width, height: txtVwAddress.frame.size.height)
        lblPlaceHolder.textColor = UIColor.init("#C4C4C6")
        lblPlaceHolder.isHidden = !txtVwAddress.text.isEmpty
        
        setTxtVwToolbar()

    }
    
    //MARK:- UserDefined Functions
    func setTxtVwToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        ]
        txtVwAddress.inputAccessoryView = toolbar
    }
    
    func validation() -> Bool {
        if txtCompanyName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Company Name", viewController: self)
        } else if txtCompanyPhone.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Company Phone", viewController: self)
        } else if txtVwAddress.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Company Address", viewController: self)
        } else if txtState.text == "" || txtState.text == "Select a State" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Company State", viewController: self)
        } else if txtCompanyCity.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Company City", viewController: self)
        } else if txtCompanyZipcode.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Company Zipcode", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    //MARK:- Actions
    @IBAction func btnDropdown(_ sender: UIButton) {
        showHideDropDown()
    }
    
    @IBAction func btnSelectImg(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnPreviousClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClick(_ button: UIButton) {
        if (self.validation()) {
            let imageData = (profileImgview.image ?? UIImage()).pngData()
            UserDefaults.standard.setValue(txtCompanyName.text ?? "", forKey: "company_name")
            UserDefaults.standard.setValue(txtCompanyPhone.text ?? "", forKey: "company_phone")
            UserDefaults.standard.setValue(txtVwAddress.text ?? "", forKey: "company_address")
            UserDefaults.standard.setValue(txtState.text ?? "", forKey: "company_state")
            UserDefaults.standard.setValue(txtCompanyCity.text ?? "", forKey: "company_city")
            UserDefaults.standard.setValue(txtCompanyZipcode.text ?? "", forKey: "company_zipcode")
            UserDefaults.standard.set(imageData, forKey: "company_logo")

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyServiceVC") as! CompanyServiceVC
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyServiceVC") as! CompanyServiceVC
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func doneAction(){
        self.txtVwAddress.resignFirstResponder()
    }
    
    func showHideDropDown() {
        if (dropdownOpen == true) {
            self.vw_dropdown.isHidden = false
            imgDropdown.image = UIImage(named: "up-arrow")
            vw_profileImgTopConstraint.constant = 100
            
            vw_companyCity.isHidden = true
            vw_companyZipcode.isHidden = true
            lblCompanyCity.isHidden = true
            lblcompanyZipcode.isHidden = true
            
            dropdownOpen = false
        } else {
            self.vw_dropdown.isHidden = true
            imgDropdown.image = UIImage(named: "down-arrow-1")
            vw_profileImgTopConstraint.constant = 15
            
            vw_companyCity.isHidden = false
            vw_companyZipcode.isHidden = false
            lblCompanyCity.isHidden = false
            lblcompanyZipcode.isHidden = false
            
            dropdownOpen = true
        }
    }
}

extension CompanyInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return arrData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dropDownTblview.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        if searching {
            cell.lblName.text = searchedCountry[indexPath.row]
        } else {
            cell.lblName.text = arrData[indexPath.row]
        }
        return cell
    }
    
}

extension CompanyInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = dropDownTblview.cellForRow(at: indexPath) as! DropdownCell
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
    }
}

extension CompanyInfoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = arrData.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        dropDownTblview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        dropDownTblview.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension CompanyInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension CompanyInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCompanyName.resignFirstResponder()
        txtCompanyPhone.resignFirstResponder()
       // txtAddress.resignFirstResponder()
        txtCompanyCity.resignFirstResponder()
        txtCompanyZipcode.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            case txtCompanyPhone:
                let text = txtCompanyPhone.text
                txtCompanyPhone.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
                return AppData.sharedInstance.textLimitForPhone(existingText: txtCompanyPhone.text, newText: string, limit: 14)
            default:
                return true
        }
    }
}

extension CompanyInfoVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.txtVwAddress.endEditing(true)
        txtVwAddress.resignFirstResponder()
    }
}
