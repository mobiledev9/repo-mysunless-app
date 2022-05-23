//
//  SelectServiceVC.swift
//  MySunless
//
//  Created by iMac on 28/02/22.
//

import UIKit
import iOSDropDown
import Alamofire

class SelectServiceVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_service: UIView!
    @IBOutlet var txtService: DropDown!
    @IBOutlet var vw_serviceProvider: UIView!
    @IBOutlet var txtServiceProvider: DropDown!
    @IBOutlet var vw_startTime: UIView!
    @IBOutlet var txtStartTime: UITextField!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrService = [SelectServiceAppointment]()
    var arrServiceName = [String]()
    var arrServiceIds = [Int]()
    var arrServiceProvider = [ProviderData]()
    var arrServiceProviderName = [String]()
    var arrServiceProviderIds = [Int]()
    var delegate: AddOrderProtocol?
    var selectedClientId = Int()
    var selectedServiceId = Int()
    var selectedServiceProviderId = Int()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callSelectServiceAPI()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK:- UserDefined Methods
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_service.layer.borderWidth = 0.5
        vw_service.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_serviceProvider.layer.borderWidth = 0.5
        vw_serviceProvider.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_startTime.layer.borderWidth = 0.5
        vw_startTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtService.delegate = self
        txtServiceProvider.delegate = self
        txtStartTime.delegate = self
    }
    
    func setValidation() -> Bool {
        if txtService.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Service", viewController: self)
        } else {
            return true
        }
        return false
    }
    
  /*  func setTimeValidation() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let time = dateFormatter.date(from: txtStartTime.text ?? "") {
            print(time)
            return true
        } else {
            AppData.sharedInstance.showAlert(title: "", message: "Please enter valid time format", viewController: self)
        }
        return false
    }     */
    
    func callSelectServiceAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + SELECT_SERVICE_APPOINTMENT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? [[String:Any]] {
                self.arrService.removeAll()
                self.arrServiceName.removeAll()
                for dict in res {
                    self.arrService.append(SelectServiceAppointment(dict: dict))
                }
                
                for item in self.arrService {
                    self.arrServiceName.append(item.serviceName)
                    self.arrServiceIds.append(item.id)
                }
                self.txtService.optionArray = self.arrServiceName
                self.txtService.optionIds = self.arrServiceIds
                self.txtService.didSelect{(selectedText, index, id) in
                    print("Selected String: \(selectedText) \n index: \(index), id: \(id)")
                    self.txtService.selectedIndex = index
                    self.selectedServiceId = id
                    self.callServiceProviderAPI(serviceID: id)
                }
            }
        }
    }
    
    func callServiceProviderAPI(serviceID: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["service_id": serviceID]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + GET_SERVICE_PROVIDER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let provider = res.value(forKey: "Provider") as? [[String:Any]] {
                    self.arrServiceProvider.removeAll()
                    
                    for dict in provider {
                        self.arrServiceProvider.append(ProviderData(dict: dict))
                    }
                    
                    for item in self.arrServiceProvider {
                        self.arrServiceProviderName.append(item.firstname + " " + item.lastname)
                        self.arrServiceProviderIds.append(item.id)
                    }
                    self.txtServiceProvider.text = self.arrServiceProvider[0].firstname + " " + self.arrServiceProvider[0].lastname
                    
                    self.txtServiceProvider.optionArray = self.arrServiceProviderName
                    self.txtServiceProvider.didSelect{(selectedText, index, id) in
                        self.txtServiceProvider.selectedIndex = index
                        self.selectedServiceProviderId = id
                    }
                }
              /*  if let info = res.value(forKey: "Info") as? NSDictionary {
                    if let price = info.value(forKey: "Price") as? String {
                        self.txtCostOfService.text = price
                    }
                    if let duration = info.value(forKey: "Duration") as? String {
                        self.txtDuration.text = duration
                    }
                }     */
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddToCart(_ sender: UIButton) {
        if setValidation() {
            self.dismiss(animated: true) {
                self.delegate?.callOrderServiceAPI(clientId: self.selectedClientId, serviceId: self.selectedServiceId, serviceProviderId: self.selectedServiceProviderId, startTime: self.txtStartTime.text ?? "")
            }
        }
    }
    
    @IBAction func btnManageServiceClick(_ sender: UIButton) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        if let conVC = storyBoard.instantiateViewController(withIdentifier: "ServicesListVC") as? ServicesListVC,
           let navController = window?.rootViewController as? UINavigationController {
            self.dismiss(animated: true, completion: nil)
            navController.pushViewController(conVC, animated: true)
        }
    }
}

extension SelectServiceVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtService.resignFirstResponder()
        txtServiceProvider.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtStartTime.resignFirstResponder()
    }
}
