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
    @IBOutlet var vw_mainViewHeight: NSLayoutConstraint!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_service: UIView!
    @IBOutlet var txtService: DropDown!
    @IBOutlet var vw_serviceProvider: UIView!
    @IBOutlet var txtServiceProvider: DropDown!
    @IBOutlet var vw_selectDate: UIView!
    @IBOutlet var txtSelectDate: UITextField!
    @IBOutlet var vw_selectTime: UIView!
    @IBOutlet var txtSelectTime: UITextField!
    @IBOutlet var vw_availableTime: UIView!
    @IBOutlet var vw_availableTimeHeight: NSLayoutConstraint!
    @IBOutlet var colviewAvailableTime: UICollectionView!
    
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
    var selectedServiceProviderTimeDuration = String()
    var arrAvailableTime = [String]() //["10.22PM","12.22PM","02.22PM","04.22PM","06.22PM"] //
    var selectedEndTime = String()
    let textFieldRecognizer = UITapGestureRecognizer()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callSelectServiceAPI()
        hideKeyboardWhenTappedAround()
        textFieldRecognizer.addTarget(self, action: #selector(tappedTextField(_:)))
        txtSelectTime.addGestureRecognizer(textFieldRecognizer)
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
        vw_selectDate.layer.borderWidth = 0.5
        vw_selectDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_selectTime.layer.borderWidth = 0.5
        vw_selectTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_availableTime.layer.borderWidth = 0.5
        vw_availableTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtService.delegate = self
        txtServiceProvider.delegate = self
        txtSelectDate.delegate = self
        txtSelectTime.delegate = self
        vw_mainViewHeight.constant = 480//680
        vw_availableTimeHeight.constant = 0//180
        vw_availableTime.isHidden = true
    }
    
    func setValidation() -> Bool {
        if txtService.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Service", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    @objc func handleStartDate() {
        if let datePicker = self.txtSelectDate.inputView as? UIDatePicker {
            datePicker.minimumDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            txtSelectDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtSelectDate.resignFirstResponder()
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
                    self.selectedServiceProviderId = self.arrServiceProvider[0].id
                    
                    self.txtServiceProvider.optionArray = self.arrServiceProviderName
                    self.txtServiceProvider.didSelect{(selectedText, index, id) in
                        self.txtServiceProvider.selectedIndex = index
                        self.selectedServiceProviderId = id
                        
                    }
                }
                if let info = res.value(forKey: "Info") as? NSDictionary {
                    if let price = info.value(forKey: "Price") as? String {
                       // self.txtCostOfService.text = price
                    }
                    if let duration = info.value(forKey: "Duration") as? String {
                        self.selectedServiceProviderTimeDuration = duration
                    }
                }
            }
        }
    }
    
  
    func callAvailableTimeSlotsAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["service_provider": selectedServiceProviderId,
                  "service_date": txtSelectDate.text ?? "" ,
                  "duration": selectedServiceProviderTimeDuration
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + AVAILABLE_TIMESLOT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let response = res.value(forKey: "response") as? [String] {
                    self.arrAvailableTime.removeAll()
                    for i in response {
                        self.arrAvailableTime.append(i)
                    }
                    self.vw_availableTime.isHidden = false
                    self.vw_availableTimeHeight.constant = 200
                    self.vw_mainViewHeight.constant = 700
                    
                    DispatchQueue.main.async {
                        self.colviewAvailableTime.reloadData()
                    }
                } else if let error = res.value(forKey: "error") as? String {
                    AppData.sharedInstance.showAlert(title: "", message: error, viewController: self)
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseStartTimeClick(_ sender: UIButton) {
        vw_mainViewHeight.constant = 480//680
        vw_availableTimeHeight.constant = 0//180
        vw_availableTime.isHidden = true
    }
    
    @IBAction func btnAddToCart(_ sender: UIButton) {
        if setValidation() {
            self.dismiss(animated: true) {
                self.delegate?.callOrderServiceAPI(clientId: self.selectedClientId, serviceId: self.selectedServiceId, serviceProviderId: self.selectedServiceProviderId, startDate: self.txtSelectDate.text ?? "", startTime: self.txtSelectTime.text ?? "")
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
    
    @objc func tappedTextField(_ sender: UITapGestureRecognizer) {
        callAvailableTimeSlotsAPI()
    }
}

extension SelectServiceVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtService.resignFirstResponder()
        txtServiceProvider.resignFirstResponder()
        if textField == txtSelectDate {
            self.txtSelectDate.setInputViewDatePicker(target: self, selector: #selector(handleStartDate))
        } else if textField == txtSelectTime {
            vw_availableTime.isHidden = false
            vw_mainViewHeight.constant = 700
            vw_availableTimeHeight.constant = 200
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSelectTime.resignFirstResponder()
    }
}
			

//MARK:- UICollectionview DataSource Methods
extension SelectServiceVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAvailableTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colviewAvailableTime.dequeueReusableCell(withReuseIdentifier: "AvailableTimeSlotsCell", for: indexPath) as! AvailableTimeSlotsCell
        cell.cellView.layer.cornerRadius = 20
        cell.lblTime.text = arrAvailableTime[indexPath.item]
        cell.lblTime.text?.removeLast(8)
        return cell
    }
}

//MARK:- UICollectionview Delegate Methods
extension SelectServiceVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}

extension SelectServiceVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var starttime = arrAvailableTime[indexPath.item]
        starttime.removeLast(8)
        selectedEndTime = starttime
        var endtime = arrAvailableTime[indexPath.item]
        endtime.removeFirst(8)
        selectedEndTime = endtime
        txtSelectTime.text = starttime
    }
}




