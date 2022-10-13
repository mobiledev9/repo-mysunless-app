//
//  MemberShipListVC.swift
//  MySunless
//
//  Created by iMac on 19/01/22.
//

import UIKit
import Alamofire
import Kingfisher
import iOSDropDown
import SCLAlertView

struct DaysData {
    let id : Int
    let value : String
    init(id:Int, value:String) {
        self.id = id
        self.value = value
    }
}

class MemberShipListVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var segementPackage: UISegmentedControl!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblPackage: UITableView!
    @IBOutlet weak var dropDown : DropDown!
    @IBOutlet var daysViewHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_days: UIView!
    @IBOutlet weak var topSearchBar: NSLayoutConstraint!     //10
    
    //MARK:- Variable Declarations
    var token = String()
    var arrActiveMember = [ActiveMember]()
    var arrFilterActiveMember = [ActiveMember]()
    var searching = false
    var selectedSegmentIndex = 0
    var arrOfDays = [DaysData(id: 1, value: "In 1 Days"),
                     DaysData(id: 2, value: "In 2 Days"),
                     DaysData(id: 3, value: "In 3 Days"),
                     DaysData(id: 7, value: "In 7 Days"),
                     DaysData(id: 10, value: "In 10 Days"),
                     DaysData(id: 15, value: "In 15 Days")
    ]
    var model = ActiveMember(dict: [:])
    var alertTitle = "Are you sure?"
    var alertSubtitle = "Once Canceled, you will lost all data of this Member Package"
    var arrPackages = [ShowPackageList]()
    var filterdata = [ShowPackageList]()
    var modelPackageList = ShowPackageList(dict: [:])
    var searchingPackageList = false
    
    var alertTitleForPackageList = "Temporary Delete?"
    var alertSubtitleForPackageList = "Once deleted, it will move to Archive list!"
    
    //MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblPackage.tableFooterView = UIView()
        searchBar.delegate = self
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
        tblPackage.refreshControl = UIRefreshControl()
        tblPackage.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      // showHideDaysView()
        showPackageData(selectedType:selectedSegmentIndex, selectedDaysIndex:dropDown.selectedIndex)
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        initDropDown()
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        segementPackage.selectedSegmentIndex = 0
        segementPackage.backgroundColor = .clear
        segementPackage.tintColor = .clear
        segementPackage.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        segementPackage.backgroundColor = UIColor.clear
        segementPackage.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size:15)!,
            NSAttributedString.Key.foregroundColor:UIColor.white 
        ], for: .selected)
      
    }
    
    //MARK:- Actions
    @IBAction func btnAddPackage(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddPackagesVC") as! AddPackagesVC
        self.navigationController?.pushViewController(VC, animated: true)
       // PackageListCell
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        //        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddPackagesVC") as! AddPackagesVC
        //        VC.isForEdit = true
        //        VC.package = searching ? arrFilterActiveMember[sender.tag] : arrActiveMember[sender.tag]
        //        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnViewClientDetailClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
      //  self.showHideDaysView()
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        showPackageData(selectedType:sender.selectedSegmentIndex, selectedDaysIndex:dropDown.selectedIndex)
    }
    
    @objc func crossButton(_ sender: UIButton) {
        if searching {
            callDeleteActivePackageAPI(cid: arrFilterActiveMember[sender.tag].cid)
            arrFilterActiveMember.remove(at: sender.tag)
        } else {
            callDeleteActivePackageAPI(cid: arrActiveMember[sender.tag].cid)
            arrActiveMember.remove(at: sender.tag)
        }
        tblPackage.reloadData()
    }
    
    @IBAction func btnEditPackage(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddPackagesVC") as! AddPackagesVC
        VC.isForEdit = true
        VC.package = searchingPackageList ? filterdata[sender.tag] : arrPackages[sender.tag]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnDeletePackage(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        if searchingPackageList {
            callDeletePackageAPI(packageId: filterdata[sender.tag].id)
            filterdata.remove(at: sender.tag)
        } else {
            callDeletePackageAPI(packageId: arrPackages[sender.tag].id)
            arrPackages.remove(at: sender.tag)
        }
         tblPackage.reloadData()
    }
    
    func showPackageData(selectedType:Int, selectedDaysIndex:Int?) {
        if selectedType == 0 {
            vw_days.isHidden = false
            topSearchBar.constant = 10
            //callUpcomingRenewalsAPI(inDays:arrOfDays[selectedDaysIndex ?? 0].id)
            callShowPackageAPI()
        }
        if selectedType == 1 {
            vw_days.isHidden = true
            topSearchBar.constant = -50
            callShowActiveMemberAPI()
        }
        if selectedType == 2 {
            vw_days.isHidden = true
            topSearchBar.constant = -50
            callCompletedAndExpiredAPI()
        }
    }
    
   /* func showHideDaysView() {
        if segementPackage.selectedSegmentIndex == 1 {
            daysViewHeight.constant = 50
            dropDown.arrowColor = UIColor.black
        } else {
            daysViewHeight.constant = 0
            dropDown.arrowColor = UIColor.clear
        }
    }     */
    
    func initDropDown() {
        dropDown.optionArray = arrOfDays.map { $0.value }
        dropDown.optionIds = arrOfDays.map { $0.id }
        dropDown.selectedIndex = 0
        dropDown.arrowColor = UIColor.black
        dropDown.didSelect{(selectedText, index, id) in
            print("Selected String: \(selectedText) \n index: \(index),id: \(id)")
            self.dropDown.selectedIndex = index
            switch selectedText {
                case "In 1 Days":
                    self.callUpcomingRenewalsAPI(inDays: 1)
                case "In 2 Days":
                    self.callUpcomingRenewalsAPI(inDays: 2)
                case "In 3 Days":
                    self.callUpcomingRenewalsAPI(inDays: 3)
                case "In 7 Days":
                    self.callUpcomingRenewalsAPI(inDays: 7)
                case "In 10 Days":
                    self.callUpcomingRenewalsAPI(inDays: 10)
                case "In 15 Days":
                    self.callUpcomingRenewalsAPI(inDays: 15)
                default:
                    print("Default")
            }
        }
    }
    
    func addRestoreAlert() {
        
        switch selectedSegmentIndex {
        case 0:
            let alert = SCLAlertView()
            alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteButton(_:)))
            alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
                
            })
            alert.iconTintColor = UIColor.white
            alert.showSuccess(alertTitleForPackageList, subTitle: alertSubtitleForPackageList)
            break
        case 1:
            let alert = SCLAlertView()
            alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(crossButton(_:)))
            alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
                
            })
            alert.iconTintColor = UIColor.white
            alert.showSuccess(alertTitle, subTitle: alertSubtitle)
            break
        default: break
        }
       
    }
    
    
    func callShowActiveMemberAPI() {
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
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_ACTIVE_MEMBER, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "message") as? [[String:Any]] {
                            self.arrActiveMember.removeAll()
                            self.arrFilterActiveMember.removeAll()
                            for dict in response {
                                self.arrActiveMember.append(ActiveMember(dict: dict))
                            }
                            self.arrFilterActiveMember = self.arrActiveMember
                            DispatchQueue.main.async {
                                self.tblPackage.reloadData()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.arrFilterActiveMember.removeAll()
                            self.arrActiveMember.removeAll()
                            self.tblPackage.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callUpcomingRenewalsAPI(inDays:Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["days":inDays]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + UPCOMING_RENEWALS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "message") as? [[String:Any]] {
                            self.arrActiveMember.removeAll()
                            self.arrFilterActiveMember.removeAll()
                            for dict in response {
                                self.arrActiveMember.append(ActiveMember(dict: dict))
                            }
                            self.arrFilterActiveMember = self.arrActiveMember
                            DispatchQueue.main.async {
                                self.tblPackage.reloadData()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.arrFilterActiveMember.removeAll()
                            self.arrActiveMember.removeAll()
                            self.tblPackage.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    func callCompletedAndExpiredAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + COMPLETED_AND_EXPIRED, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "message") as? [[String:Any]] {
                            self.arrActiveMember.removeAll()
                            self.arrFilterActiveMember.removeAll()
                            for dict in response {
                                self.arrActiveMember.append(ActiveMember(dict: dict))
                            }
                            self.arrFilterActiveMember = self.arrActiveMember
                            DispatchQueue.main.async {
                                self.tblPackage.reloadData()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            self.arrActiveMember.removeAll()
                            self.arrFilterActiveMember.removeAll()
                            self.tblPackage.reloadData()
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteActivePackageAPI(cid:Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["cid":cid]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_ACTIVE_PACKAGE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.showPackageData(selectedType:self.segementPackage.selectedSegmentIndex,selectedDaysIndex:self.dropDown.selectedIndex )
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            
                        }
                    }
                }
            }
        }
    }
    //Package list API
    func callShowPackageAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PACKAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrPackages.removeAll()
                            for dict in response {
                                self.arrPackages.append(ShowPackageList(dict: dict))
                            }
                            self.filterdata = self.arrPackages
                            DispatchQueue.main.async {
                                self.tblPackage.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrPackages.removeAll()
                            self.filterdata.removeAll()
                            self.tblPackage.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callDeletePackageAPI(packageId:Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id":packageId]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_PACKAGE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callShowPackageAPI()
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
    
    func filterContentForSearchText(_ searchText: String) {
        switch selectedSegmentIndex {
        case 0 :
            filterdata = arrPackages.filter({ (package:ShowPackageList) -> Bool in
                let name = package.name
                let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let price = "$" + "\(package.price)"
                let Price = price.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let packageDate = package.tracking
                let PackageDate = packageDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let visit = "\(package.noofvisit)"
                let Visit = visit.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let desc = package.description
                let Desc = desc.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                return Name != nil || Price != nil || PackageDate != nil || Visit != nil || Desc != nil
            })
            break
        case 1:
            arrFilterActiveMember = arrActiveMember.filter({ (activeMember:ActiveMember) -> Bool in
                let clientname = "\(activeMember.firstName)" + " " + "\(activeMember.lastName)"
                let ClientName = clientname.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let name = activeMember.name
                let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let packageStartDate = activeMember.packageStartDate
                let PackageStartDate = packageStartDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let packageExpireDate = activeMember.packageExpireDate
                let PackageExpireDate = packageExpireDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let visit = activeMember.noofvisit
                let Visit = visit.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                let username = activeMember.username
                let Username = username.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                return ClientName != nil || Name != nil || PackageStartDate != nil || PackageExpireDate != nil || Visit != nil || Username != nil
            })
            break
        default: break
        }
       
    }
    
    @objc func callPullToRefresh(){
        
        switch selectedSegmentIndex {
        case 0:
            DispatchQueue.main.async {
                self.callShowPackageAPI()
                self.tblPackage.refreshControl?.endRefreshing()
                self.tblPackage.reloadData()
            }
            break
        case 1:
            DispatchQueue.main.async {
                self.showPackageData(selectedType:self.segementPackage.selectedSegmentIndex,selectedDaysIndex:self.dropDown.selectedIndex)
                self.tblPackage.refreshControl?.endRefreshing()
                self.tblPackage.reloadData()
            }
            break
        default:
            break
        }
    }
    
}
//MARK:- TableView Delegate and Datasource Methods
extension MemberShipListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegmentIndex {
        case 0 :
            if searchingPackageList {
                return filterdata.count
            } else {
                return arrPackages.count
            }
        case 1:
            if searching {
                return arrFilterActiveMember.count
            } else {
                return arrActiveMember.count
            }
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSegmentIndex {
        case 0 :
            let cell = tblPackage.dequeueReusableCell(withIdentifier: "PackageListCell", for: indexPath) as! PackageListCell
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            if searchingPackageList {
                modelPackageList = filterdata[indexPath.row]
            } else {
                modelPackageList = arrPackages[indexPath.row]
            }
            cell.lblName.text = modelPackageList.name
            cell.lblPrice.text = "$" + modelPackageList.price
            cell.lblPackageDate.text = modelPackageList.tracking
            cell.lblRemainingVisit.text  = modelPackageList.noofvisit
            cell.lblDescription.text = modelPackageList.description
            return cell
        case 1 :
            let cell = tblPackage.dequeueReusableCell(withIdentifier: "PackageCell", for: indexPath) as! PackageCell
            if searching {
                model = arrFilterActiveMember[indexPath.row]
            } else {
                model = arrActiveMember[indexPath.row]
            }
            cell.lblClientName.text = model.firstName + model.lastName
            cell.lblPackageName.text = model.name
            cell.lblPackageStartDate.text = model.packageStartDate
            cell.lblPackageEndDate.text = model.packageExpireDate
            cell.lblServiceRemaining.text = model.noofvisit
            cell.lblEmployeeSold.text = model.username
            let url = URL(string: model.profileImg)
            if model.profileImg != "" {
                cell.imgClient.kf.setImage(with: url)
            } else {
                cell.imgClient.image = UIImage(named: "user-profile")
            }
            return cell
          default:
            return UITableViewCell()
        }
        
    }
}

extension MemberShipListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedSegmentIndex {
            case 0 :
            return UITableView.automaticDimension

        case 1 :
            return 210
       
        default:
            return 0
        }
       
       
    }
}

//MARK:- SearchBar Delegate Methods
extension MemberShipListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterActiveMember = arrActiveMember
            }
            tblPackage.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblPackage.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

