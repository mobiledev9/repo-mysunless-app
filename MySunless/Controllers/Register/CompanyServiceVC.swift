//
//  CompanyServiceVC.swift
//  MySunless
//
//  Created by iMac on 13/10/21.
//

import UIKit

class CompanyServiceVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_Main: UIView!
    @IBOutlet var vw_workingStartTime: UIView!
    @IBOutlet var txtWorkingStartTime: UITextField!
    @IBOutlet var vw_workingEndTime: UIView!
    @IBOutlet var txtWorkingEndTime: UITextField!
    @IBOutlet var vw_service: UIView!
    @IBOutlet var txtService: UITextField!
    @IBOutlet var vw_price: UIView!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var vw_serviceDuration: UIView!
    @IBOutlet var txtServiceDuration: UITextField!
    @IBOutlet var vw_appointmentInst: UIView!
    @IBOutlet var txtVwAppointmentInst: UITextView!
    @IBOutlet var vw_localSalesRate: UIView!
    @IBOutlet var txtLocalSalesRate: UITextField!
    @IBOutlet var vw_dropdown: UIView!
    @IBOutlet var imgDropdown: UIImageView!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var dropDownTblView: UITableView!
    @IBOutlet var lblAppointmentInst: UILabel!
    @IBOutlet var lblLocalSalesTaxRate: UILabel!
    
    //MARK:- Variable Declarations
    var dropdownOpen = true
    var arrData = [String]()
    var searchedCountry = [String]()
    var searching = false
    var selected: String?
    var lblPlaceHolder : UILabel!
    var dict = [String:Any]()
    
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
        
        vw_workingStartTime.layer.borderWidth = 0.5
        vw_workingStartTime.layer.borderColor = UIColor.gray.cgColor
        vw_workingEndTime.layer.borderWidth = 0.5
        vw_workingEndTime.layer.borderColor = UIColor.gray.cgColor
        vw_service.layer.borderWidth = 0.5
        vw_service.layer.borderColor = UIColor.gray.cgColor
        vw_price.layer.borderWidth = 0.5
        vw_price.layer.borderColor = UIColor.gray.cgColor
        vw_serviceDuration.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_serviceDuration.layer.borderWidth = 0.5
        vw_appointmentInst.layer.borderColor = UIColor.gray.cgColor
        vw_appointmentInst.layer.borderWidth = 0.5
        vw_localSalesRate.layer.borderWidth = 0.5
        vw_localSalesRate.layer.borderColor = UIColor.gray.cgColor
        
        vw_dropdown.layer.borderWidth = 0.5
        vw_dropdown.layer.borderColor = UIColor.gray.cgColor
        
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.gray.cgColor
        
        vw_dropdown.isHidden = true
        searchBar.delegate = self
        
        txtService.delegate = self
        txtPrice.delegate = self
        txtVwAppointmentInst.delegate = self
        txtLocalSalesRate.delegate = self
        txtWorkingStartTime.delegate = self
        txtWorkingEndTime.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        arrData = serviceDuration
        
        lblPlaceHolder = UILabel()
        lblPlaceHolder.text = "Appointment Instruction (Any information entered into this section will appear as an appointment instruction on the confirmation email that will be sent upon booking this specific service.)"
      //  lblPlaceHolder.font = UIFont.systemFont(ofSize: txtVwAppointmentInst.font!.pointSize)
        lblPlaceHolder.font = UIFont(name: "Roboto-Regular", size: 17)
        lblPlaceHolder.sizeToFit()
        lblPlaceHolder.numberOfLines = 10
        txtVwAppointmentInst.addSubview(lblPlaceHolder)
        lblPlaceHolder.frame.origin = CGPoint(x: 5, y: 0)
        lblPlaceHolder.frame.size = CGSize(width: vw_appointmentInst.frame.size.width, height: vw_appointmentInst.frame.size.height)
        lblPlaceHolder.textColor = UIColor.init("#C4C4C6")
        lblPlaceHolder.isHidden = !txtVwAppointmentInst.text.isEmpty
        
        setTxtVwToolbar()
        
      //  txtVwAppointmentInst.frame = CGRect(x: vw_appointmentInst.frame.origin.x, y: vw_appointmentInst.frame.origin.y, width: vw_appointmentInst.frame.size.width, height: vw_appointmentInst.frame.size.height)
       
    }
    
    //MARK:- User-Defined Functions
    func setTxtVwToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        ]
        txtVwAppointmentInst.inputAccessoryView = toolbar
    }
    
    func validation() -> Bool {
        if txtWorkingStartTime.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter start time", viewController: self)
        } else if txtWorkingEndTime.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter end time", viewController: self)
        } else if txtService.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Service Name", viewController: self)
        } else if txtPrice.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Service Price", viewController: self)
        } else if txtServiceDuration.text == "" || txtServiceDuration.text == "Select Service Duration" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Service Duration", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    @objc func handleFromStartTime() {
        if let datePicker = self.txtWorkingStartTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            txtWorkingStartTime.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtWorkingStartTime.resignFirstResponder()
    }
    
    @objc func handleFromEndTime() {
        if let datePicker = self.txtWorkingEndTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            txtWorkingEndTime.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtWorkingEndTime.resignFirstResponder()
    }
    
    //MARK:- Actions
    @IBAction func btnDropdownClick(_ sender: UIButton) {
        if (dropdownOpen == true) {
            self.vw_dropdown.isHidden = false
            imgDropdown.image = UIImage(named: "up-arrow")
            
            vw_appointmentInst.isHidden = true
            vw_localSalesRate.isHidden = true
            lblAppointmentInst.isHidden = true
            lblLocalSalesTaxRate.isHidden = true
            
            dropdownOpen = false
        } else {
            self.vw_dropdown.isHidden = true
            imgDropdown.image = UIImage(named: "down-arrow-1")
            
            vw_appointmentInst.isHidden = false
            vw_localSalesRate.isHidden = false
            lblAppointmentInst.isHidden = false
            lblLocalSalesTaxRate.isHidden = false
            
            dropdownOpen = true
        }
    }
    
    @IBAction func btnPreviousClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
//        dict = ["company_service":txtService.text ?? "","service_price":txtPrice.text ?? "","service_duration":txtServiceDuration.text ?? "","instruction":txtVwAppointmentInst.text ?? "","tax_rate":txtLocalSalesRate.text ?? ""]
//        UserDefaults.standard.setValue(dict, forKey: "CompanyServiceInfo")
//        print("CompanyService:-",dict)
        
        if (self.validation()) {
            UserDefaults.standard.setValue(txtWorkingStartTime.text ?? "", forKey: "starttime")
            UserDefaults.standard.setValue(txtWorkingEndTime.text ?? "", forKey: "endtime")
             UserDefaults.standard.setValue(txtService.text ?? "", forKey: "company_service")
            UserDefaults.standard.setValue(txtPrice.text ?? "", forKey: "service_price")
            UserDefaults.standard.setValue(txtServiceDuration.text ?? "", forKey: "service_duration")
            UserDefaults.standard.setValue(txtVwAppointmentInst.text ?? "", forKey: "instruction")
            UserDefaults.standard.setValue(txtLocalSalesRate.text ?? "", forKey: "tax_rate")

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChoosePackageVC") as! ChoosePackageVC
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChoosePackageVC") as! ChoosePackageVC
//        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @objc func doneAction(){
        self.txtVwAppointmentInst.resignFirstResponder()
    }
    
}

extension CompanyServiceVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return arrData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dropDownTblView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        if searching {
            cell.lblName.text = searchedCountry[indexPath.row]
        } else {
            cell.lblName.text = arrData[indexPath.row]
        }
        return cell
    }
    
}

extension CompanyServiceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = dropDownTblView.cellForRow(at: indexPath) as! DropdownCell
        txtServiceDuration.text = cell.lblName.text
        
        if searching {
            let selectedCountry = searchedCountry[indexPath.row]
            selected = selectedCountry
        } else {
            let selectedCountry = arrData[indexPath.row]
            selected = selectedCountry
        }
        
        self.searchBar.searchTextField.endEditing(true)
        //  dropdownTblview.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CompanyServiceVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = arrData.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        dropDownTblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        dropDownTblView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()   
    }
}

extension CompanyServiceVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.txtVwAppointmentInst.endEditing(true)
        txtVwAppointmentInst.resignFirstResponder()
    }
}

//MARK:- Textfield Delegate Methods
extension CompanyServiceVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtService.resignFirstResponder()
        txtPrice.resignFirstResponder()
       // txtVwAppointmentInst.resignFirstResponder()
        txtLocalSalesRate.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtWorkingStartTime {
            self.txtWorkingStartTime.setInputViewDatePicker(target: self, selector: #selector(handleFromStartTime),pickerMode: .time)
        } else if textField == txtWorkingEndTime {
            self.txtWorkingEndTime.setInputViewDatePicker(target: self, selector: #selector(handleFromEndTime), pickerMode: .time)
        }
        
    }
}

