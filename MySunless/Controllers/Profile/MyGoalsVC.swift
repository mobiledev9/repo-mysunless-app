//
//  MyGoalsVC.swift
//  MySunless
//
//  Created by Daydream Soft on 08/06/22.
//

import UIKit
import Alamofire

class MyGoalsVC: UIViewController {
    
    @IBOutlet var vw_selectClientGoal: UIView!
    @IBOutlet var txtClientGoal: UITextField!
    @IBOutlet var btnClientGoal: UIButton!
    @IBOutlet var imgClientGoalDropdown: UIImageView!
    @IBOutlet var vw_clientGoalDropdown: UIView!
    @IBOutlet var tblVwClientGoal: UITableView!
    @IBOutlet var vw_selectSalesGoal: UIView!
    @IBOutlet var txtSalesGoal: UITextField!
    @IBOutlet var btnSalesGoal: UIButton!
    @IBOutlet var imgSalesGoalDropdown: UIImageView!
    @IBOutlet var vw_salesGoalDropdown: UIView!
    @IBOutlet var tblVwSalesGoal: UITableView!
    @IBOutlet var lblSalesGoal: UILabel!
    
    var token = String()
    var clientGoalDropdownOpen = true
    var salesGoalDropdownOpen = true
    var arrClientGoal = [String]()
    var arrSalesGoal = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        arrClientGoal = clientGoalList
        arrSalesGoal = salesGoalList
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setInitially() {
        vw_selectClientGoal.layer.borderWidth = 0.5
        vw_selectClientGoal.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_selectSalesGoal.layer.borderWidth = 0.5
        vw_selectSalesGoal.layer.borderColor = UIColor.init("15B0DA").cgColor
        
        vw_clientGoalDropdown.layer.borderWidth = 0.5
        vw_clientGoalDropdown.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_salesGoalDropdown.layer.borderWidth = 0.5
        vw_salesGoalDropdown.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_clientGoalDropdown.isHidden = true
        vw_salesGoalDropdown.isHidden = true
    }
    
    func saveGoalsValidation() -> Bool {
        if txtClientGoal.text == "Select Client Goal" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Client Goal", viewController: self)
        } else if txtSalesGoal.text == "Select Sales Goal" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Sales Goal", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callSaveGoalsAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = ["clientgoal":Int(txtClientGoal.text!) ?? 0,
                  "salesgoal":Int(txtSalesGoal.text!) ?? 0]
        
        let headers: HTTPHeaders = ["Authorization":token]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SAVE_GOALS, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let result = res.value(forKey: "result") as? Int {
                    if (result == 1) {
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
    
    @IBAction func btnClientGoalClick(_ sender: UIButton) {
        showHideClientGoal()
    }
    
    @IBAction func btnSalesGoalClick(_ sender: UIButton) {
        showHideSalesGoal()
    }
    
    @IBAction func btnSaveMyGoalsClick(_ sender: UIButton) {
        if (self.saveGoalsValidation()) {
            callSaveGoalsAPI()
        }
    }
    
   func showHideClientGoal(){
       if (clientGoalDropdownOpen == true) {
        self.vw_clientGoalDropdown.isHidden = false
        imgClientGoalDropdown.image = UIImage(named: "up-arrow")
        
        lblSalesGoal.isHidden = true
        vw_selectSalesGoal.isHidden = true
        btnSalesGoal.isHidden = true
        imgSalesGoalDropdown.isHidden = true
        
        clientGoalDropdownOpen = false
    } else {
        self.vw_clientGoalDropdown.isHidden = true
        imgClientGoalDropdown.image = UIImage(named: "down-arrow-1")
        
        lblSalesGoal.isHidden = false
        vw_selectSalesGoal.isHidden = false
        btnSalesGoal.isHidden = false
        imgSalesGoalDropdown.isHidden = false
        
        clientGoalDropdownOpen = true
    }}
    
    func showHideSalesGoal() {
        if (salesGoalDropdownOpen == true) {
            self.vw_salesGoalDropdown.isHidden = false
            imgSalesGoalDropdown.image = UIImage(named: "up-arrow")
            salesGoalDropdownOpen = false
        } else {
            self.vw_salesGoalDropdown.isHidden = true
            imgSalesGoalDropdown.image = UIImage(named: "down-arrow-1")
            salesGoalDropdownOpen = true
        }
    }

}

extension MyGoalsVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblVwClientGoal {
            return 1
        } else if tableView == tblVwSalesGoal {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwClientGoal {
            return arrClientGoal.count
        } else if tableView == tblVwSalesGoal {
            return arrSalesGoal.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwClientGoal {
            let cell = tblVwClientGoal.dequeueReusableCell(withIdentifier: "CompanyTypeCell", for: indexPath) as! CompanyTypeCell
            cell.lblTitle.text = arrClientGoal[indexPath.row]
            return cell
        } else if tableView == tblVwSalesGoal {
            let cell = tblVwSalesGoal.dequeueReusableCell(withIdentifier: "CompanyTypeCell", for: indexPath) as! CompanyTypeCell
            cell.lblTitle.text = arrSalesGoal[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension MyGoalsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwClientGoal {
            return 40
        } else if tableView == tblVwSalesGoal {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwClientGoal {
            let cell = tblVwClientGoal.cellForRow(at: indexPath) as! CompanyTypeCell
            txtClientGoal.text = cell.lblTitle.text
            showHideClientGoal()
        } else if tableView == tblVwSalesGoal {
            let cell = tblVwSalesGoal.cellForRow(at: indexPath) as! CompanyTypeCell
            txtSalesGoal.text = cell.lblTitle.text
            showHideSalesGoal()
        }
    }
}

