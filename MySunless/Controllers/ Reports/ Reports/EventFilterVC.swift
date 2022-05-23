//
//  EventFilterVC.swift
//  MySunless
//
//  Created by iMac on 04/02/22.
//

import UIKit
import iOSDropDown
import Alamofire

//MARK:- Main Class
class EventFilterVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_eventDate: UIView!
    @IBOutlet var eventDateDropdown: DropDown!
    @IBOutlet var vw_chooseUser: UIView!
    @IBOutlet var chooseUserDropdown: DropDown!
    @IBOutlet var vw_chooseCustomer: UIView!
    @IBOutlet var chooseCustomerDropdown: DropDown!
    @IBOutlet var vw_filterStatus: UIView!
    @IBOutlet var filterStatusDropdown: DropDown!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrChooseUser = [ChooseUser]()
    var arrChooseCustomer = [ChooseCustomerList]()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
        eventDateDropdown.optionArray = ["Today","Yesterday","Last 7 Days","Last 30 Days","This Month","Last Month","Year to Date","Custom Range"]
        eventDateDropdown.didSelect{(selectedText , index ,id) in
            print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
            self.eventDateDropdown.selectedIndex = index
        }
        
        filterStatusDropdown.optionArray = ["completed","pending","confirmed","canceled","pending-payment","in-progress"]
        filterStatusDropdown.didSelect{(selectedText , index ,id) in
            print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
            self.filterStatusDropdown.selectedIndex = index
        }
        
        callFilterListUserAPI()
        callFilterListCustomerAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        vw_bottom.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
        vw_eventDate.layer.borderWidth = 0.5
        vw_eventDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseUser.layer.borderWidth = 0.5
        vw_chooseUser.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseCustomer.layer.borderWidth = 0.5
        vw_chooseCustomer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_filterStatus.layer.borderWidth = 0.5
        vw_filterStatus.layer.borderColor = UIColor.init("#15B0DA").cgColor
    }
    
    func callFilterListUserAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + FILTER_CHOOSE_USER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? [[String:Any]] {
                self.arrChooseUser.removeAll()
                for dict in res {
                    self.arrChooseUser.append(ChooseUser(dict: dict))
                }

                self.chooseUserDropdown.optionArray = self.arrChooseUser.map { $0.firstname + " " + $0.lastname }
                self.chooseUserDropdown.didSelect{(selectedText , index ,id) in
                    print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
                    self.chooseUserDropdown.selectedIndex = index
                }
            }
        }
    }
    
    func callFilterListCustomerAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + FILTER_CHOOSE_CUSTOMER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? [[String:Any]] {
                self.arrChooseCustomer.removeAll()
                for dict in res {
                    self.arrChooseCustomer.append(ChooseCustomerList(dict: dict))
                }
                self.chooseCustomerDropdown.optionArray = self.arrChooseCustomer.map { $0.FirstName + " " + $0.LastName }
                self.chooseCustomerDropdown.didSelect{(selectedText , index ,id) in
                    print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
                    self.chooseCustomerDropdown.selectedIndex = index
                }
            }
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
    }
    
}
