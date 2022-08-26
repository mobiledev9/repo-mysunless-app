//
//  PerformanceListVC.swift
//  MySunless
//
//  Created by iMac on 28/02/22.
//

import UIKit
import Alamofire
import Kingfisher

protocol FilterPerformanceListProtocol {
    func updatePerformanceList(DateDatas : (String,Int)?,
                               filterBadgeCount: Int)
}

class PerformanceListVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblPerformanceList: UITableView!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet weak var lblBadgeCount: UILabel!
    
    //MARK:- Variable Declarations
    var arrPerformanceList = [ShowPerformance]()
    var arrSearchedPerformance = [ShowPerformance]()
    var token = String()
    var searching = false
    var model = ShowPerformance(dict: [:])
    var valSelctedDates : (String,Int) = ("",-1)
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        tblPerformanceList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        searchBar.delegate = self
        callShowPerformanceAPI()
        tblPerformanceList.refreshControl = UIRefreshControl()
        tblPerformanceList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnFilter.layer.borderWidth = 0.5
        btnFilter.layer.borderColor = UIColor.init("#15B0DA").cgColor
    }
    
    func callShowPerformanceAPI(isFilter : Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if isFilter! {
            var dict :[String:String] = [:]
            if valSelctedDates != ("",-1) {
                dict["date"] = valSelctedDates.0
            }
            
            params = dict as NSDictionary
        } else {
            params = [:]
        }
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PERFORMANCE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
                AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                    AppData.sharedInstance.dismissLoader()
                }
                return
            }
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrPerformanceList.removeAll()
                            for dict in response {
                                self.arrPerformanceList.append(ShowPerformance(dict: dict))
                            }
                            self.arrSearchedPerformance = self.arrPerformanceList
                            DispatchQueue.main.async {
                                self.tblPerformanceList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrPerformanceList.removeAll()
                            self.arrSearchedPerformance.removeAll()
                            self.tblPerformanceList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrSearchedPerformance = arrPerformanceList.filter({ (performanceList: ShowPerformance) -> Bool in
            let username = performanceList.username
            let UserName = username.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let appBook = "\(performanceList.app_book)"
            let AppBook = appBook.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let appConfirm = "\(performanceList.app_confirm)"
            let AppConfirm = appConfirm.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let email = "\(performanceList.email)"
            let Email = email.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let sms = "\(performanceList.sms)"
            let SMS = sms.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let orderNo = "\(performanceList.order_no)"
            let OrderNo = orderNo.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return UserName != nil || AppBook != nil || AppConfirm != nil || Email != nil || SMS != nil || OrderNo != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowPerformanceAPI()
            self.tblPerformanceList.refreshControl?.endRefreshing()
            self.tblPerformanceList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryFilterVC") as! PaymentHistoryFilterVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.isFromPerformanceList = true
        VC.delegateOfPerformanceList = self
        VC.valSelctedPaymentDate = self.valSelctedDates
        self.present(VC, animated: true, completion: nil)
    }

}

//MARK:- UITableView Datasource Methods
extension PerformanceListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrSearchedPerformance.count
        } else {
            return arrPerformanceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPerformanceList.dequeueReusableCell(withIdentifier: "PerformanceListCell", for: indexPath) as! PerformanceListCell
        
        if searching {
            model = arrSearchedPerformance[indexPath.row]
        } else {
            model = arrPerformanceList[indexPath.row]
        }
        
        let empimgUrl = URL(string: model.userimg)
        cell.empImg.kf.setImage(with: empimgUrl)
        cell.empName.text = model.username
        cell.lblAppointmentBooked.text = "\(model.app_book)"
        cell.lblAppointmentConfirmed.text = "\(model.app_confirm)"
        cell.lblEmail.text = "\(model.email)"
        cell.lblSMS.text = "\(model.sms)"
        cell.lblOrder.text = "\(model.order_no)"
        
        return cell
    }
    
}

//MARK:- UITableView Delegate Methods
extension PerformanceListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

//MARK:- SearchBar Delegate Methods
extension PerformanceListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrSearchedPerformance = arrPerformanceList
            }
            tblPerformanceList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblPerformanceList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
extension PerformanceListVC : FilterPerformanceListProtocol {
    func updatePerformanceList(DateDatas: (String, Int)?, filterBadgeCount: Int) {
        valSelctedDates = DateDatas ?? ("",-1)
        self.lblBadgeCount.text = "\(filterBadgeCount)"
        callShowPerformanceAPI(isFilter: true)
        
    }
    
    
}
